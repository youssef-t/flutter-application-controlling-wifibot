
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/commands.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/data_wifibot.dart';

///  Class to manage the TCP connection  with the Wifibot.
class ConnectionTCP {
  Socket? _socketWifiBot;




  /// Timeout duration in seconds.
  final int _timeoutDuration = 10;

  /// Variable used to know if the data request is accepted
  bool dataRequestingIsInitialized = false;

  ConnectionTCP();

  Future<void> connect() async {

  }

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


}

