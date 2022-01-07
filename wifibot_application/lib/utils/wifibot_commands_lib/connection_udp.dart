import 'dart:io';
import 'dart:async';

import 'package:wifibot_application/utils/wifibot_commands_lib/commands.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/constants_wifibot.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/data_wifibot.dart';

///  Class to manage the UDP connection  with the Wifibot.
class ConnectionUDP {
  RawDatagramSocket? _socketWifiBotDataUDP;
  RawDatagramSocket? _socketWifiBotCommandsUDP;

  // A broadcast stream in case we need to listen to the stream multiple times
  Stream<RawSocketEvent>? _socketWifibotDataUDPBroadcastStream;

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

  /// Variable used to know if the data request is accepted
  static bool _dataRequestingIsInitialized = false;

  bool get dataRequestingIsInitialized => _dataRequestingIsInitialized;

  /// Variable used to stop getting data from wifibot
  static bool _stopGettingDataFromWifiBot = false;

  String _wifibotIPAddress = WifibotConstants.wifiBotIPAddressDefault;
  int _udpPortWifibotCommands = WifibotConstants.udpPortWifibotCommandsDefault;
  int _udpPortWifibotData = WifibotConstants.udpPortWifibotDataDefault;

  String cameraIPAddress = WifibotConstants.cameraIPAddressDefault;
  int cameraPort = WifibotConstants.cameraPortDefault;

  /// Constructor to set, if necessary, [wifiBotIPAddress], [udpPortWifibotSendCommand] and [udpPortWifibotReceiveData]
  ConnectionUDP(
      {String wifiBotIPAddress = WifibotConstants.wifiBotIPAddressDefault,
      int udpPortWifibotSendCommand =
          WifibotConstants.udpPortWifibotCommandsDefault,
      int udpPortWifibotReceiveData =
          WifibotConstants.udpPortWifibotDataDefault}) {
    _wifibotIPAddress = wifiBotIPAddress;
    _udpPortWifibotCommands = udpPortWifibotSendCommand;
    _udpPortWifibotData = udpPortWifibotReceiveData;
  }

  /// Method to call in order to initialize sockets used for UDP
  Future<void> initializeStreamsAndSockets() async {
    print("IN itializeStreamsAndSockets()");
    // reopen streams in case disconnect method was called
    _streamMessagesController = StreamController<String>.broadcast();
    _streamDataWifibotController = StreamController<DataWifibot>.broadcast();

    try {
      // Wifibot is using 2 channels: one for data and another one for sending commands
      // Setting the socket that will be used for requesting data and receiving it
      await RawDatagramSocket.bind(InternetAddress.anyIPv4, _udpPortWifibotData, reuseAddress: true)
          .then((RawDatagramSocket socketData) {
        _socketWifiBotDataUDP = socketData;
        _socketWifibotDataUDPBroadcastStream = socketData.asBroadcastStream();

        // Adding to the stream the received messages
        _socketWifibotDataUDPBroadcastStream?.listen((eventSentByWifibot) {
          // TODO ADD RECEIVE METHOD TO GET UDP MESSAGES
          Datagram? dg = _socketWifiBotDataUDP?.receive();
          print("IN LISTEN : ${dg?.data}");
          if(dg?.data != null){
            String messageSentByWifibot = String.fromCharCodes(dg!.data);
            print("IN LISTEN -  $messageSentByWifibot - THE MESSAGE IS ADDED");
            _streamMessagesController.add(messageSentByWifibot);
          }
        });
        print("SocketWifibotDataUDP has been initialised");
      }).onError((error, stackTrace) {
        print("SocketWifibotDataUDP - ERROR INITIALIZATION UDP: \n$error\n $stackTrace");
      });

      // Setting the socket that will send commands
      await RawDatagramSocket.bind(InternetAddress.anyIPv4, _udpPortWifibotCommands, reuseAddress: true)
          .then((RawDatagramSocket socketCommands) {
        _socketWifiBotCommandsUDP = socketCommands;
        print("SocketWifibotCommandsDataUDP has been initialised");
      });
    } catch(e, s) {
      print('----Exception when trying to create UDP sockets: \n $e, \n ----Trace: \n $s');
    }

  }

  // TODO Change isCommand to true by default
  /// Method to send a message to the wifibot.
  /// The parameter [isCommand] is set to true if we want to send a command to the wifibot.
  /// This is set to false if we want to send a message (for requesting data for example)
  void send(String message, {bool isCommand = false}) {
    isCommand
        ? _socketWifiBotCommandsUDP?.send(message.codeUnits,
            InternetAddress(_wifibotIPAddress), _udpPortWifibotCommands)
        : _socketWifiBotDataUDP?.send(message.codeUnits,
            InternetAddress(_wifibotIPAddress), _udpPortWifibotData);
    print("The message : - $message - is sent");
  }

  /// Initialize data requesting from wifibot by sending "init" and then we wait to receive as a response "ok"
  Future<void> initializeDataRequestingFromWifibot() async {
    // Then we proceed to resquest data from wifibot
    // First, we need to send the message "init"
    if (!_dataRequestingIsInitialized) {
      send("init", isCommand: false);
      String response = "";
      // Get the response of the wifibot
      // We declare a subscription so that we stop listening to the stream once we get "ok" as a response
      StreamSubscription<RawSocketEvent>? subscription;
      subscription =
          _socketWifibotDataUDPBroadcastStream?.listen((eventSentByWifibot) {
            Datagram? dg = _socketWifiBotDataUDP?.receive();
            if (dg != null){
              response = String.fromCharCodes(dg.data);
            }
            // Then the robot should respond once with "ok".
            if (response.toLowerCase().trim() == "ok") {
              _dataRequestingIsInitialized = true;
              print("OK IS RECEIVED");
              subscription?.cancel();
            } else {
              print("WARNING - OK NOT RECEIVED / response : ${response.toLowerCase().trim()}");
            }
          });
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
      _socketWifibotDataUDPBroadcastStream?.listen((lastMessageByWifibotRawSocketEvent) {
        print(
            "IN gettingDataFromWifibot - lastMessageByWifibot: ${lastMessageByWifibotRawSocketEvent.toString()}");
        DataWifibot dataWifibot = DataWifibot.withRawDataPacketString(lastMessageByWifibotRawSocketEvent.toString());
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
  void close() {
      _socketWifiBotDataUDP?.close();
      _socketWifiBotCommandsUDP?.close();

      _streamMessagesController.close();
      _streamDataWifibotController.close();
      stopGettingDataFromWifibot();

      _dataRequestingIsInitialized = false;
      print("UDP - closed");
    }


}
