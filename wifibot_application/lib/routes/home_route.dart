
import 'package:flutter/material.dart';


/// Class that represents the first page of our app
class HomeRoute extends StatelessWidget {

  // Defining the style of the buttons
  static const fontSizeButton = 30.0;
  static const textButtonStyle = TextStyle(
    fontSize: fontSizeButton,
  );


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Wifibot Controller"),
        actions: [
          // TODO add a function to create a route for the settings page
          IconButton(onPressed: settingsIconButtonPushed, icon: Icon(Icons.settings, color: Colors.black,) )
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
          child: ElevatedButton(
            // TODO add a function to create a route for the controller page
            onPressed: controllerButtonPushed,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50), // double.infinity is the width and 50 is the height
            ),
            child: Text("Controller", style: textButtonStyle, ),

          ),
        ),
      ),
    );
  }
}

// TODO to define
void settingsIconButtonPushed() async {

}

// TODO to define
void controllerButtonPushed() {

}