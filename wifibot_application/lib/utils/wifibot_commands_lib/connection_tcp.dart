
import 'dart:convert';
import 'dart:io';

import 'package:wifibot_application/utils/wifibot_commands_lib/commands.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/data_wifibot.dart';

///  Class to manage the TCP connection  with the Wifibot
class ConnectionTCP {

  Socket? _socketWifiBot;

  //TODO change the IP address
  dynamic _wifiBotIPAddress = "127.0.0.1";
  final int _tcpPortWifibot = 15020;

  ConnectionTCP();

  Future<void> connect() async {
    try {
      _socketWifiBot = await Socket.connect(_wifiBotIPAddress, _tcpPortWifibot);
    } on SocketException catch (e) {
      print('SocketException: $e');
    } catch(e) {
      print('Exception when trying to connect: $e');
    }
      print('Connected');
    }


  void send(String commandString) {
    _socketWifiBot?.add(utf8.encode('hello'));
  }

  void receive(DataWifibot dataWifibot){

  }

  void run() {

  }

  void disconnect(){
    _socketWifiBot?.close();
  }


}
