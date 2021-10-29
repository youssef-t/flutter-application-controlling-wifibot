
import 'package:flutter/material.dart';
import 'package:joystick/joystick.dart';

class ControllerRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // load the controller route that is defined in the package controller_route
    /*
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    */

    return Stack(
      children: [
        // placeholder for game
        Container(
          color: Colors.purple,
        ),

        Container(
          decoration: FlutterLogoDecoration(
          ),
          child: Joystick(size: 100,
            isDraggable: true,
            iconColor: Colors.amber,
            backgroundColor: Colors.black,
            opacity: 0.5,
            joystickMode: JoystickModes.horizontal,),
        ),
      ],
    );
  }
}

