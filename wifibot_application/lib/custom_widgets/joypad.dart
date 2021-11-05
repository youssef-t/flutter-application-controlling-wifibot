import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class Joypad extends StatefulWidget {
  @override
  _JoypadState createState() => _JoypadState();
}

class _JoypadState extends State<Joypad> {
  @override
  Widget build(BuildContext context) {
    return Joystick(
      period: Duration(milliseconds: 500),
      mode: JoystickMode.all,
      base: JoystickBase(mode: JoystickMode.all),
      stickOffsetCalculator: const CircleStickOffsetCalculator(),
      listener: (details) {
    setState(() {
      print(" x: ${details.x} - y : ${details.y}");
    });
      },
    );
  }
}
