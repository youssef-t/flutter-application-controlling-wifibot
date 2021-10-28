

import 'package:flutter/material.dart';
import 'package:wifibot_application/CustomWidgets/settings_form.dart';

/// Class that represents the settings page of our app
class SettingsRoute extends StatelessWidget {

  // Defining the style of the buttons
  static const fontSizeButton = 30.0;
  static const textButtonStyle = TextStyle(
    fontSize: fontSizeButton,
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SettingsForm(),
    );
  }
}

// TODO to define
void settingsIconButtonPushed() {

}

// TODO to define
void controllerButtonPushed() {

}