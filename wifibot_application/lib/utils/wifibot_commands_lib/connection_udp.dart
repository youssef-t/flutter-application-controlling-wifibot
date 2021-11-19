
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/commands.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/constants_wifibot.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/data_wifibot.dart';

///  Class to manage the UDP connection  with the Wifibot.
class ConnectionUDP {

  static String wifibotIPAddress = WifibotConstants.wifiBotIPAddressDefault;
  static int udpPortWifibotSendCommand = WifibotConstants.udpPortWifibotSendCommandDefault;
  static int udpPortWifibotReceiveData = WifibotConstants.udpPortWifibotReceiveDataDefault;

  static String cameraIPAddress = WifibotConstants.cameraIPAddressDefault;
  static int cameraPort = WifibotConstants.cameraPortDefault;

  ConnectionUDP();


  /// Method to send a command to the wifibot
  void send(String commandString)  {

  }

  /// Receiving messages from the wifibot
  String receive() {
    String wifiBotResponse = "";

    RawDatagramSocket.bind(wifibotIPAddress, udpPortWifibotReceiveData).then((RawDatagramSocket socket){
      print('Datagram socket ready to receive');
      print('${socket.address.address}:${socket.port}');
      socket.listen((RawSocketEvent e){
        Datagram? d = socket.receive();
        if (d == null) return;

        wifiBotResponse = String.fromCharCodes(d.data).trim();
        print('Datagram from ${d.address.address}:${d.port}: $wifiBotResponse');
      });
    });

    return wifiBotResponse;
  }

  /// Request data from the robot
  Map? receiveDataWifiBot() {

    Map? dataWifibotMap;



    return dataWifibotMap;
  }

}

