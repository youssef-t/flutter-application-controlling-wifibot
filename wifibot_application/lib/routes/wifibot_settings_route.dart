import 'package:flutter/material.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/constants_wifibot.dart';
import 'package:regexed_validator/regexed_validator.dart';


class FormSettings extends StatefulWidget {
  @override
  _FormSettingsState createState() => _FormSettingsState();
}

class _FormSettingsState extends State<FormSettings> {
  final formKey = GlobalKey<FormState>();

  String wifibotIpAddress = WifibotConstants.wifiBotIPAddressDefault;
  int wifibotPort = WifibotConstants.tcpPortWifibotDefault;
  String cameraIpAddress = WifibotConstants.cameraIPAddressDefault;
  int cameraPort = WifibotConstants.cameraPortDefault;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wifibot settings"),
      ),
      body: Form(
        key: formKey,
        //autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            buildWifibotIpAddress(),
            const SizedBox(height: 16),
            buildWifibotPort(),
            const SizedBox(height: 32),
            buildCameraIpAddress(),
            const SizedBox(height: 32),
            buildCameraPort(),
          ],
        ),
      ),
    );
  }
  // TODO COMPLETE THE FORM
  Widget buildWifibotIpAddress() => TextFormField(
    decoration: InputDecoration(
      labelText: 'Wifibot IP address',
      border: OutlineInputBorder(),
    ),
    initialValue: WifibotConstants.wifiBotIPAddressDefault,
    validator: (value) {
      if(value != null) {
        if (validator.ip(value)) {
          return 'Enter an email';
        } else {
          return 'Enter a valid ip address';
        }
      }
       else {
        return null;
      }
    },
    keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
    onSaved: (value) => setState(() => wifibotIpAddress = value ?? WifibotConstants.wifiBotIPAddressDefault),
  );

  Widget buildWifibotPort() => TextFormField();
  Widget buildCameraIpAddress() => TextFormField();
  Widget buildCameraPort() => TextFormField();
}


