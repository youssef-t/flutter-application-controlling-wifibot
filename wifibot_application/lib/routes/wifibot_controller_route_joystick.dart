import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wifibot_application/custom_widgets/custom_joystick.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/commands.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/connection_tcp.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/constants_wifibot.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'dart:convert';
import 'package:sensors_plus/sensors_plus.dart';


class ControllerRouteJoystick extends StatefulWidget {
  @override
  _ControllerRouteJoystickState createState() => _ControllerRouteJoystickState();
}

class _ControllerRouteJoystickState extends State<ControllerRouteJoystick> {
  late ConnectionTCP _conn;
  double _xJoystick = 0;
  double _yJoystick = 0;
  bool _isJoystickUpdating = false;
  CommandWifibot _commandWifibot = CommandWifibot();

  late Timer _timerSendCommand;
  late Timer _timerUpdateXandY;

  @override
  Widget build(BuildContext context) {
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
    _timerUpdateXandY = _updateXandYWhenNoValueFromJoystick();
    _timerSendCommand = _sendCommandToWifibotFromXAndY();

  }

  @override
  void dispose() {
    _conn.close();
    _timerUpdateXandY.cancel();
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
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Row(
              children: [
                SizedBox(
                    height: 130,
                    width: 130,
                    child: FittedBox(
                      child: CustomJoystick(
                        listenerJoypadOnChange: (stickDragDetails) {
                          _updateXandYFromJoystick(
                              stickDragDetails.x, stickDragDetails.y);
                        },
                      ),
                    )),
              ],
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

  void _updateXandYFromJoystick(x, y) {
    setState(() {
      _xJoystick = x;
      _yJoystick = y;
      _isJoystickUpdating = true;
    });
  }

  Timer _updateXandYWhenNoValueFromJoystick() => Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        if (!_isJoystickUpdating) {
          _xJoystick = 0;
          _yJoystick = 0;
        }
        _isJoystickUpdating = false;
      });
    });


  Timer _sendCommandToWifibotFromXAndY() => Timer.periodic(const Duration(milliseconds: 160), (timer) {
      setState(() {
        _commandWifibot.setSpeedFromXandY(-_xJoystick, -_yJoystick);
        _conn.sendCommand(_commandWifibot);
      });
    });

}
