
import 'package:flutter/material.dart';
import 'package:wifibot_application/custom_widgets/custom_joystick.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/constants_wifibot.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class ControllerRoute extends StatefulWidget {
  @override
  _ControllerRouteState createState() => _ControllerRouteState();
}

class _ControllerRouteState extends State<ControllerRoute> {
  @override
  Widget build(BuildContext context) {
    return Stack(

      children: [
        /*Container(
          color: Colors.blue,
        ),*/

        InteractiveViewer(
          child: Mjpeg(
            fit: BoxFit.contain,
            stream: "http://192.168.1.106:8080/?action=stream",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            isLive: true,
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




