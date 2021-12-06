import 'package:flutter/material.dart';

import '../route_generator.dart';

// Defining the style of the buttons
const fontSizeButton = 30.0;
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
        title: Text("Wifibot Controller"),
        actions: [
          IconButton(
              // Go to the settings route
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ))
        ],
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(),
                ElevatedButton(
                  // Go the controller route
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.controller);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity,
                        50), // double.infinity is the width and 50 is the height
                  ),
                  child: const Text(
                    "Controller",
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
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
