
import 'package:flutter/material.dart';
import 'package:wifibot_application/custom_widgets/custom_joystick.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/connection_tcp.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/constants_wifibot.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class ControllerRoute extends StatefulWidget {
  @override
  _ControllerRouteState createState() => _ControllerRouteState();
}

class _ControllerRouteState extends State<ControllerRoute> {

  late ConnectionTCP _conn;

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }

  @override
  void initState(){
    super.initState();
    _conn = ConnectionTCP();
    _conn.connect(wifiBotIPAddress: WifibotConstants.wifiBotIPAddressDefault,
        wifiBotTCPPort: WifibotConstants.tcpPortWifibotDefault,
        timeoutDuration:  WifibotConstants.timeoutDurationTCPDefault);
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
                      size: MediaQuery.of(context).size.height/15,
                    ),
                    Text("Failed to connect to camera",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: MediaQuery.of(context).size.height/20
                    ),)
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
                      child: CustomJoystick(listenerJoypadOnChange: (stickDragDetails) {
                        print("x : ${stickDragDetails.x} - y : ${stickDragDetails.y}");
                      },),
                    )
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
  }




