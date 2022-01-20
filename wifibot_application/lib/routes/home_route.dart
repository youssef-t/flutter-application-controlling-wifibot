import 'package:flutter/material.dart';

import '../route_generator.dart';

// Defining the style of the buttons
const fontSizeButton = 25.0;
const textButtonStyle = TextStyle(
  fontSize: fontSizeButton,
);

/// Class that represents the first page of our app
class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wifibot Controller"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Spacer(),
            ElevatedButton(
              // Go the controller route
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.controllerJoystick);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity,
                    50), // double.infinity is the width and 50 is the height
              ),
              child: const Text(
                "Controller with Joystick",
                style: textButtonStyle,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              // Go the controller route
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.controllerGyroscope);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity,
                    50), // double.infinity is the width and 50 is the height
              ),
              child: const Text(
                "Controller with Gyroscope",
                style: textButtonStyle,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              // Go the controller route
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.testCommunication);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity,
                    50), // double.infinity is the width and 50 is the height
              ),
              child: const Center(
                child: Text(
                  "Test Communication",
                  style: textButtonStyle,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
