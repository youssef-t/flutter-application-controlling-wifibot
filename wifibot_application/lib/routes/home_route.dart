import 'package:flutter/material.dart';

// Defining the style of the buttons
const fontSizeButton = 30.0;
const textButtonStyle = TextStyle(
  fontSize: fontSizeButton,
);

/// Class that represents the first page of our app
class HomeRoute extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wifibot Controller"),
        actions: [
          IconButton(
              // Go to the settings route
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ))
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
          child: ElevatedButton(
            // Go the controller route
            onPressed: () {
              Navigator.pushNamed(context, '/controller');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity,
                  50), // double.infinity is the width and 50 is the height
            ),
            child: Text(
              "Controller",
              style: textButtonStyle,
            ),
          ),
        ),
      ),
    );
  }
}


