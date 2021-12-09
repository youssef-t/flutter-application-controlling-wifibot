import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/commands.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/constants_wifibot.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/data_wifibot.dart';

///  Class to manage the TCP connection  with the Wifibot.
class ConnectionTCP {
  Socket? _socketWifiBot;
  Socket? get socketWifiBot => _socketWifiBot;
  // A broadcast stream in case we need to listen to the stream multiple times
  Stream<Uint8List>? _socketWifiBotBroadcastStream;

  /// A stream controller that returns in the stream the received messages
  StreamController<String> _streamMessagesController =
      StreamController<String>.broadcast();
  StreamController<String>? get streamMessagesController =>
      _streamMessagesController;

  /// A stream controller that returns in the stream an object of type [DataWifibot] that contains a map indicating the meaning of the received packets
  StreamController<DataWifibot> _streamDataWifibotController =
      StreamController<DataWifibot>.broadcast();
  StreamController<DataWifibot> get streamDataWifibotController =>
      _streamDataWifibotController;

  Stream<String>? get streamMessage => _streamMessagesController.stream;

  static bool _wifibotIsConnected = false;

  /// Variable used to stop getting data from wifibot
  static bool _stopGettingDataFromWifiBot = false;

  /// Variable used to know if the data request is accepted
  static bool _dataRequestingIsInitialized = false;
  bool get dataRequestingIsInitialized => _dataRequestingIsInitialized;

  ConnectionTCP(
      {String wifiBotIPAddress = WifibotConstants.wifiBotIPAddressDefault,
      int wifiBotTCPPort = WifibotConstants.tcpPortWifibotDefault,
      int timeoutDuration = WifibotConstants.timeoutDurationTCPDefault}) {
    connect(
        wifiBotIPAddress: wifiBotIPAddress,
        wifiBotTCPPort: wifiBotTCPPort,
        timeoutDuration: timeoutDuration);
  }

  /// Method to connect to the wifibot using TCP
  Future<void> connect(
      {String wifiBotIPAddress = WifibotConstants.wifiBotIPAddressDefault,
      int wifiBotTCPPort = WifibotConstants.tcpPortWifibotDefault,
      int timeoutDuration = WifibotConstants.timeoutDurationTCPDefault}) async {
    try {
      // reopen streams in case disconnect method was called
      _streamMessagesController = StreamController<String>.broadcast();
      _streamDataWifibotController = StreamController<DataWifibot>.broadcast();

      print("Starting the connection");

      await Socket.connect(wifiBotIPAddress, wifiBotTCPPort)
          .timeout(Duration(seconds: timeoutDuration))
          .then((socket) {
        initializeStreamsAndSocketWhenConnected(socket);
      });
    } on SocketException catch (e, s) {
      print('SocketException: $e, \n Trace: $s');
      _wifibotIsConnected = false;
    } catch (e, s) {
      print('Exception when trying to connect: $e, \n Trace $s');
      _wifibotIsConnected = false;
    }

    _wifibotIsConnected ? print("Connected") : print("NOT CONNECTED");
  }

  /// Method to call when the connection is successful
  void initializeStreamsAndSocketWhenConnected(Socket socket) {
    _socketWifiBot = socket;
    _socketWifiBotBroadcastStream = socket.asBroadcastStream();
    print("_socketBroadcast: ${_socketWifiBotBroadcastStream?.isBroadcast}");
    //print("_socket: ${_socketWifiBot.runtimeType}");
    print(
        "_streamMessagesController : ${_streamMessagesController.runtimeType}");
    // Listening to the stream (tcp messages) and configuring the streams that will be used in the UI
    _socketWifiBotBroadcastStream?.listen((event) {
      print("IN LISTEN : ${String.fromCharCodes(event)}");
      _streamMessagesController.add(String.fromCharCodes(event));
    });
    _wifibotIsConnected = true;
  }

  /// Method to send a command to the wifibot after the connection
  Future<void> send(String commandString) async {
    if (!_wifibotIsConnected) {
      await connect();
    }
    print("IN SEND - _socketWifibot type : ${_socketWifiBot.runtimeType}");
    _socketWifiBot?.add(utf8.encode(commandString));
    //_socketWifiBot?.write(commandString);
    print('Command "$commandString" is sent');
  }

  /// Initialize data requesting from wifibot by sending "init" and then we wait to receive as a response "ok"
  Future<void> initializeDataRequestingFromWifibot() async {
    // Then we proceed to resquest data from wifibot
    if (_wifibotIsConnected) {
      // First, we need to send the message "init"
      if (!_dataRequestingIsInitialized) {
        await send("init");
        String response = "";
        // Get the response of the wifibot
        // We declare a subscription so that we stop listening to the stream once we get "ok" as a response
        StreamSubscription<Uint8List>? subscription;
        subscription =
            _socketWifiBotBroadcastStream?.listen((messageByWifibot) {
          response = String.fromCharCodes(messageByWifibot);
          // Then the robot should respond once with "ok".
          if (response.toLowerCase().trim() == "ok") {
            _dataRequestingIsInitialized = true;
            print("OK IS RECEIVED");
            subscription?.cancel();
          } else {
            print("WARNING - OK NOT RECEIVED / response : $response");
          }
        });
      }
    }
  }

  /// We request the data periodically each [intervalMillisecondsForRequestingData].
  /// We stop getting the data by calling the method [stopGettingDataFromWifibot].
  Future<void> gettingDataFromWifiBot(
      {int intervalMillisecondsForRequestingData =
          WifibotConstants.intervalMillisecondsForRequestingData}) async {
    // When we call the method at the beginning, we make sure not to stop requesting data
    if (_stopGettingDataFromWifiBot) {
      _stopGettingDataFromWifiBot = false;
    }

    if (_dataRequestingIsInitialized) {
      // Adding the data to the stream containing the Data related to the wifibot
      _socketWifiBotBroadcastStream?.listen((lastMessageByWifibot) {
        print(
            "IN gettingDataFromWifibot - lastMessageByWifibot: ${String.fromCharCodes(lastMessageByWifibot)}");
        DataWifibot dataWifibot = DataWifibot(lastMessageByWifibot);
        _streamDataWifibotController.add(dataWifibot);
        dataWifibot.showData();
      });
      while (!_stopGettingDataFromWifiBot) {
        // send "data" so that the wifibot sends back a packet containing information about it
        send("data");
        await Future.delayed(
            Duration(milliseconds: intervalMillisecondsForRequestingData));
      }
    } else {
      print("data requesting is not initialized");
    }
  }

  void stopGettingDataFromWifibot() {
    _stopGettingDataFromWifiBot = true;
  }

  /// Close the TCP connection
  void disconnect() {
    if (_wifibotIsConnected) {
      _socketWifiBot?.close();
      _streamMessagesController.close();
      _streamDataWifibotController.close();
      stopGettingDataFromWifibot();

      _wifibotIsConnected = false;
      _dataRequestingIsInitialized = false;
      print("Disconnected");
    } else {
      print("wifibot is already disconnected - disconnect method");
    }
  }
}
