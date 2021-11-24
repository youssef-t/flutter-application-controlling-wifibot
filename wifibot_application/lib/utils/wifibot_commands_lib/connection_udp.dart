
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/commands.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/constants_wifibot.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/data_wifibot.dart';

///  Class to manage the UDP connection  with the Wifibot.
class ConnectionUDP {

  String wifibotIPAddress = WifibotConstants.wifiBotIPAddressDefault;
  int udpPortWifibotSendCommand = WifibotConstants.udpPortWifibotSendCommandDefault;
  int udpPortWifibotReceiveData = WifibotConstants.udpPortWifibotReceiveDataDefault;

  String cameraIPAddress = WifibotConstants.cameraIPAddressDefault;
  int cameraPort = WifibotConstants.cameraPortDefault;

  bool dataRequestingIsInitialized = false;

  /// Constructor to change the default parameters
  ConnectionUDP(
      this.wifibotIPAddress,
      this.udpPortWifibotSendCommand,
      this.udpPortWifibotReceiveData,
      this.cameraIPAddress,
      this.cameraPort
      );

  /// Method to send a command to the wifibot
  void send(String commandString)  {
    RawDatagramSocket.bind(wifibotIPAddress, udpPortWifibotSendCommand).then((RawDatagramSocket socket){
      print('Datagram socket ready to send');
      print('${socket.address.address}:${socket.port}');

      // Sending the packet to the wifibot
      socket.send(commandString.codeUnits, socket.address, udpPortWifibotSendCommand);
    });
  }

  /// Receiving messages from the wifibot as a String
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

