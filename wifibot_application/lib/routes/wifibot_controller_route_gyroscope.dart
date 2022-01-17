import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/commands.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/connection_tcp.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/constants_wifibot.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'dart:convert';
import 'package:sensors_plus/sensors_plus.dart';


class ControllerRouteGyroscope extends StatefulWidget {
  @override
  _ControllerRouteGyroscopeState createState() => _ControllerRouteGyroscopeState();
}

class _ControllerRouteGyroscopeState extends State<ControllerRouteGyroscope> {
  late ConnectionTCP _conn;
  double _xGyroscope = 0;
  double _yGyroscope = 0;
  CommandWifibot _commandWifibot = CommandWifibot();

  late Timer _timerSendCommand;

  @override
  Widget build(BuildContext context) {

    gyroscopeEvents.listen((GyroscopeEvent event) {
      print(event);
    });

    return _buildView();
  }

  @override
  void initState() {
    super.initState();
    _conn = ConnectionTCP();
    _conn.connect(
        wifiBotIPAddress: WifibotConstants.wifiBotIPAddressDefault,
        wifiBotTCPPort: WifibotConstants.tcpPortWifibotDefault,
        timeoutDuration: WifibotConstants.timeoutDurationTCPDefault);
    _timerSendCommand = _sendCommandToWifibotFromXAndY();

  }

  @override
  void dispose() {
    _conn.close();
    _timerSendCommand.cancel();
    super.dispose();
  }

  Widget _buildView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: InteractiveViewer(
            child: Mjpeg(
              fit: BoxFit.contain,
              stream: "http://192.168.1.106:8080/?action=stream",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              isLive: true,
              error: (context, error, stack) {
                return Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: MediaQuery.of(context).size.height / 15,
                    ),
                    Text(
                      "Failed to connect to camera",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: MediaQuery.of(context).size.height / 20),
                    )
                  ],
                );
              },
            ),
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: StreamBuilder(
            stream: _conn.streamDataWifibotController.stream,
            initialData: "No data",
            builder: (
                BuildContext context,
                AsyncSnapshot<dynamic> snapshot) {
              String _textToDisplay = json.encode(snapshot.data.dataWifibotMap);
              return RichText(
                  text: TextSpan(
                    text: 'Wifibot response: ',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: _textToDisplay,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ));

            },

          ),
        )
      ],
    );
  }


  Timer _sendCommandToWifibotFromXAndY() => Timer.periodic(const Duration(milliseconds: 160), (timer) {
      _commandWifibot.setSpeedFromXandY(-_xGyroscope, -_yGyroscope);
      _conn.sendCommand(_commandWifibot);
    });

}
