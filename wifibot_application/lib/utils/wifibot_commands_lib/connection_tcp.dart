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

  static bool _wifibotIsConnected = false;

  /// Variable used to know if the data request is accepted
  bool dataRequestingIsInitialized = false;

  ConnectionTCP();

  /// Method to connect to the wifibot using TCP
  Future<void> connect({String wifiBotIPAddress = WifibotConstants.wifiBotIPAddressDefault, int wifiBotTCPPort = WifibotConstants.tcpPortWifibotDefault, int timeoutDuration = WifibotConstants.timeoutDurationTCPDefault}) async {
    try {
      print("Starting the connection");
      _socketWifiBot = await Socket.connect(wifiBotIPAddress, wifiBotTCPPort)
          .timeout(Duration(seconds: timeoutDuration))
          .whenComplete(() => _wifibotIsConnected = true);
    } on SocketException catch (e, s) {
      print('SocketException: $e, \n Trace: $s');
      _wifibotIsConnected = false;
    } catch (e, s) {
      print('Exception when trying to connect: $e, \n Trace $s');
      _wifibotIsConnected = false;
    }

    _wifibotIsConnected ? print("Connected") : print("NOT CONNECTED");
  }

  /// Method to send a command to the wifibot after the connection
  void send(String commandString)  {
    if (_wifibotIsConnected) {
      _socketWifiBot?.add(utf8.encode(commandString));
      print('Command "$commandString" is sent');
    } else {
      print("NOT CONNECTED - send method");
    }
  }

  String receive() {
    String wifiBotResponse = "";
    if (_wifibotIsConnected) {
      _socketWifiBot?.listen((Uint8List data) {
        wifiBotResponse = String.fromCharCodes(data);
        print('Wifibot Response: $wifiBotResponse');
      });
    } else {
      print("NOT CONNECTED - receive method");
    }
    return wifiBotResponse;
  }

  /// Request data from the robot
  Map? receiveDataWifiBot() {

    Map? dataWifibotMap;

    if (_wifibotIsConnected) {
      // We need to send the message "init" at first.
      if(!dataRequestingIsInitialized){
        send("init");
        String response = receive();
        // Then the robot should respond once with "OK".
        if(response == "ok"){
          dataRequestingIsInitialized = true;
        } else {
          print("WARNING - OK NOT RECEIVED");
        }

      }

      // Then we request the data
      if(dataRequestingIsInitialized){
        send("data");
        String rawDataString = receive();
        DataWifibot dataWifibot = DataWifibot.withRawDataPacketString(rawDataString);
        dataWifibotMap = dataWifibot.dataWifibotMap;
      }
    }
    else {
      print("NOT CONNECTED - receiveDataWifiBot");
    }

    return dataWifibotMap;
  }

  /// Close the TCP connection
  void disconnect() {
    if (_wifibotIsConnected) {
      _socketWifiBot?.close();
      _wifibotIsConnected = false;
      dataRequestingIsInitialized = false;
      print("Disconnected");
    } else {
      print("wifibot is already disconnected - disconnect method");
    }
  }
}
