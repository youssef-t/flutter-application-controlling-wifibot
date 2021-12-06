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
  Stream<Uint8List>? _socketWifiBotBroadcastStream;
  StreamController<String> _streamMessagesController = StreamController<String>.broadcast();

  StreamController<String>? get streamMessagesController =>
      _streamMessagesController;

  Stream<String>? get streamMessage => _streamMessagesController.stream;

  Socket? get socketWifiBot => _socketWifiBot;
  static bool _wifibotIsConnected = false;

  /// Variable used to know if the data request is accepted
  bool _dataRequestingIsInitialized = false;

  bool get dataRequestingIsInitialized => _dataRequestingIsInitialized;

  ConnectionTCP(){
    connect();
  }

  /// Method to connect to the wifibot using TCP
  Future<void> connect({String wifiBotIPAddress = WifibotConstants.wifiBotIPAddressDefault, int wifiBotTCPPort = WifibotConstants.tcpPortWifibotDefault, int timeoutDuration = WifibotConstants.timeoutDurationTCPDefault}) async {
    try {
      print("Starting the connection");
      _socketWifiBot = await Socket.connect(wifiBotIPAddress, wifiBotTCPPort)
          .timeout(Duration(seconds: timeoutDuration))
          .whenComplete(() {
            _wifibotIsConnected = true;
      });
    } on SocketException catch (e, s) {
      print('SocketException: $e, \n Trace: $s');
      _wifibotIsConnected = false;
    } catch (e, s) {
      print('Exception when trying to connect: $e, \n Trace $s');
      _wifibotIsConnected = false;
    }

    _socketWifiBotBroadcastStream = _socketWifiBot?.asBroadcastStream();
    print("_socketBroadcast: ${_socketWifiBotBroadcastStream?.isBroadcast}");
    print("_socket: ${_socketWifiBot.runtimeType}");
    print("_streamMessagesController : ${_streamMessagesController.runtimeType}");
    _socketWifiBotBroadcastStream?.listen((event) {
      print("IN LISTEN : ${String.fromCharCodes(event)}");
      _streamMessagesController.add(String.fromCharCodes(event));
    }
    );


    _wifibotIsConnected ? print("Connected") : print("NOT CONNECTED");
  }

  /// Method to send a command to the wifibot after the connection
  void send(String commandString)  {
    if (_wifibotIsConnected) {
      //_socketWifiBot?.add(utf8.encode(commandString));
      if(_socketWifiBot == null) {
        connect();
      }
      _socketWifiBot?.write(commandString);
      print('Command "$commandString" is sent');
    } else {
      print("NOT CONNECTED - send method");
    }
  }

  // TODO To remove this method
  /// Method to get a stream of the messages sent by the wifibot
  Stream<String> receive({Function(Uint8List data)? callback}) async* {
    /*String wifiBotResponse = "";
    bool hasChanged = false;

    //if (_wifibotIsConnected) {

    Stream<String>? listMessages = _socketWifiBotBroadcastStream?.map((event) {
      print("STRING FROM CHARCODES : ${String.fromCharCodes(event)}");
      return String.fromCharCodes(event);
    });

    _socketWifiBotBroadcastStream?.listen((event) {print("IN LISTEN ${String.fromCharCodes(event)}");});

    await for (final String chunk in listMessages??const Stream.empty()) {
      print("chunk: $chunk");
      yield chunk;
    }

      *//*_socketWifiBot?.asBroadcastStream().listen(callback ?? (Uint8List data) {
        wifiBotResponse = String.fromCharCodes(data);
        hasChanged = true;
        print('Wifibot Response: $wifiBotResponse');
      });*//*

      *//*
        if(false)//if(hasChanged)
        {
          //yield wifiBotResponse;
          hasChanged = false;
        }

       *//*

      //yield _socketWifiBot?.last?.toString() ?? "Null receive";

    //} else {
      //print("NOT CONNECTED - receive method");
    //}
    //yield _socketWifiBot?.last?.toString() ?? "Null receive";


*/


  }



  /// TODO Change receiveDataWifiBot to return a Map then call the method in the constructor
  /// Method to request data from the robot and to get a stream of maps
  /// containing the data sent by the wifibot
  Stream<Map> receiveDataWifiBot() async* {

    Map dataWifibotMap = {};

    // Verify of the wifibot is connected.
    if (_wifibotIsConnected) {
      // First, we need to send the message "init"
      if(!_dataRequestingIsInitialized){
        send("init");
        String response = "";
        // Get the response of the wifibot
        receive().listen((messageByWifibot) {
          response = messageByWifibot;
        });
        // Then the robot should respond once with "ok".
        if(response == "ok"){
          _dataRequestingIsInitialized = true;
        } else {
          print("WARNING - OK NOT RECEIVED");
        }

      }

      // Then we request the data
      if(_dataRequestingIsInitialized){
        send("data");
        String rawDataString = "";
        receive().listen((messageByWifibot) {
          rawDataString = messageByWifibot;
        });
        DataWifibot dataWifibot = DataWifibot.withRawDataPacketString(rawDataString);
        dataWifibotMap = dataWifibot.dataWifibotMap;
      }
    }
    else {
      print("NOT CONNECTED - receiveDataWifiBot");
    }

    yield dataWifibotMap;
  }

  /// Close the TCP connection
  void disconnect() {
    if (_wifibotIsConnected) {
      _socketWifiBot?.close();
      _streamMessagesController.close();

      _wifibotIsConnected = false;
      _dataRequestingIsInitialized = false;
      print("Disconnected");
    } else {
      print("wifibot is already disconnected - disconnect method");
    }

  }
}
