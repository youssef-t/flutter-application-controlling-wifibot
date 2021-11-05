
import 'package:flutter/material.dart';
import 'package:wifibot_application/custom_widgets/joypad.dart';

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
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          color: Colors.blue,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: ),
          child: Row(
            children: [
              SizedBox(
                  height: 130,
                  width: 130,
                  child: FittedBox(
                    child: Joypad(),
                  )
              ),
            ],
          ),
        )
      ],
    );
  }
}

