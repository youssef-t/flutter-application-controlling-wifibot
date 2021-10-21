
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/commands.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/data_wifibot.dart';

///  Class to manage the TCP connection  with the Wifibot
class ConnectionTCP {

  Socket? _socketWifiBot;

  //TODO change the IP address
  String _wifiBotIPAddress = "127.0.0.1";
  final int _tcpPortWifibot = 15020;

  static bool wifibotIsConnected = false;

  /**
   * Timeout duration in seconds
   */
  final int _timeoutDuration = 10;

  ConnectionTCP();

  Future<void> connect() async {
    try {
      print("Starting the connection");
      _socketWifiBot = await Socket.connect(_wifiBotIPAddress, _tcpPortWifibot)
          .timeout(Duration(seconds: _timeoutDuration)).whenComplete(() => wifibotIsConnected = true);
    } on SocketException catch (e, s) {
      print('SocketException: $e, \n Trace: $s');
      wifibotIsConnected = false;
    } catch(e, s) {
      print('Exception when trying to connect: $e, \n Trace $s');
      wifibotIsConnected = false;
    }

    wifibotIsConnected ? print("Connected") : print("NOT CONNECTED");

    }


  void send(String commandString) {
    if(wifibotIsConnected){
      _socketWifiBot?.add(utf8.encode(commandString));
      print('Command \"$commandString\" is sent');
    }
    else {
      print("NOT CONNECTED - send method");
    }
  }

  void receive(){
    if(wifibotIsConnected){
      _socketWifiBot?.listen((Uint8List data) {
        final wifiBotResponse = String.fromCharCodes(data);
        print('Wifibot Response: $wifiBotResponse');
      });
    }

    else {
      print("NOT CONNECTED - receive method");
    }


  }

  void disconnect(){
    if(wifibotIsConnected){
      _socketWifiBot?.close();
      wifibotIsConnected = false;
      print("Disconnected");
    }
    else {
      print("wifibot is already disconnected - disconnect method");
    }
  }



}
