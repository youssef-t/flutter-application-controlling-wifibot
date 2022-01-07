import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wifibot_application/custom_widgets/custom_joystick.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/commands.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/connection_tcp.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/constants_wifibot.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class ControllerRoute extends StatefulWidget {
  @override
  _ControllerRouteState createState() => _ControllerRouteState();
}

class _ControllerRouteState extends State<ControllerRoute> {
  late ConnectionTCP _conn;
  double _xJoystick = 0;
  double _yJoystick = 0;
  bool _isJoystickUpdating = false;
  CommandWifibot _commandWifibot = CommandWifibot();

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
    _updateXandYWhenNoValueFromJoystick();
    _sendCommandToWifibotFromXAndY(this._xJoystick, this._yJoystick);
  }

  @override
  void dispose() {
    _conn.close();
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

  void _updateXandYWhenNoValueFromJoystick() {
    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        if (!_isJoystickUpdating) {
          _xJoystick = 0;
          _yJoystick = 0;
        }
        _isJoystickUpdating = false;
      });
      print("x : ${this._xJoystick}, y : ${this._yJoystick}");
    });
  }

  void _sendCommandToWifibotFromXAndY(double x, double y) {
    // TODO Change setAction parameters
    this._commandWifibot.setAction(10, 10, Direction.forward);
  }
}
