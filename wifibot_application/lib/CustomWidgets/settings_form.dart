import 'package:flutter/material.dart';

// Define a custom form.
/// Class that represents the settings form for the Robot
class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

// Define a corresponding State class.
// This class holds data related to the form.
class _SettingsFormState extends State<SettingsForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          // TODO Add the necessary settings fields
          children: <Widget>[
            // Widget to represent the text field for the IP adress
            TextFormField(
              // The validator receives the text that the user has entered.
              // In our case, it's an IP adress field
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid IP adress';
                }
                return null;
              },

            ),
          ],
        ));
  }
}



