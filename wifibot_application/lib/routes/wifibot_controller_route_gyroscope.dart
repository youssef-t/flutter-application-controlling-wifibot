import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/commands.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/connection_tcp.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/constants_wifibot.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'dart:convert';
import 'package:sensors_plus/sensors_plus.dart';

class ControllerRouteGyroscope extends StatefulWidget {
  @override
  _ControllerRouteGyroscopeState createState() =>
      _ControllerRouteGyroscopeState();
}

class _ControllerRouteGyroscopeState extends State<ControllerRouteGyroscope> {
  late ConnectionTCP _conn;
  double _xGyroscope = 0.0;
  double _yGyroscope = 0.0;
  bool _stop = false;
  CommandWifibot _commandWifibot = CommandWifibot();

  late Timer _timerSendCommand;

  @override
  Widget build(BuildContext context) {
    Stopwatch stopwatch = Stopwatch()..start();
    gyroscopeEvents.listen((GyroscopeEvent event) {
      //print("EVENT : $event");
      //print('Event executed in ${stopwatch.elapsed}');
      double timeElapsedInSeconds = stopwatch.elapsedMilliseconds / 1000;
      _xGyroscope -= event.x * timeElapsedInSeconds / (pi);
      _yGyroscope += event.y * timeElapsedInSeconds / (pi);
      stopwatch.reset();
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
            stream: _conn.streamDataWifibotController.stream
                .map((event) => json.encode(event.dataWifibotMap)),
            initialData: "No data",
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              String _textToDisplay = json.encode(snapshot.data);
              return Text(
                "Wifibot response: $_textToDisplay",
                style: TextStyle(color: Colors.blue, fontSize: 20),
              );
            },
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Material(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(
                  Icons.refresh_outlined,
                  color: Colors.blue,
                ),
                onPressed: () {
                  _xGyroscope = 0;
                  _yGyroscope = 0;
                },
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Material(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                icon: _stop
                    ? const Icon(
                        Icons.play_arrow,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.stop,
                        color: Colors.red,
                      ),
                onPressed: () {
                  setState(() {
                    _stop ? _stop = false : _stop = true;
                  });
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Timer _sendCommandToWifibotFromXAndY() =>
      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        /*if (_xGyroscope > 1) {
          _xGyroscope = 1;
        } else if (_xGyroscope < -1) {
          _xGyroscope = -1;
        }

        if (_yGyroscope > 1) {
          _yGyroscope = 1;
        } else if (_yGyroscope < -1) {
          _yGyroscope = -1;
        }*/

        print("x : $_xGyroscope - y : $_yGyroscope");
        if (_stop) {
          _commandWifibot.setSpeedFromXandY(0, 0);
        } else {
          _commandWifibot.setSpeedFromXandY(_xGyroscope, _yGyroscope);
        }
        _conn.sendCommand(_commandWifibot);
      });
}
