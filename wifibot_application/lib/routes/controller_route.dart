
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Controller page"),
      ),
    );
  }
}

