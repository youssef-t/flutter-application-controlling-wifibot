import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';


class CustomJoystick extends StatefulWidget {
  final Function(StickDragDetails) listenerJoypadOnChange;

  CustomJoystick({Key? key,
    required this.listenerJoypadOnChange(StickDragDetails stickDragDetails),
  }) : super(key: key);

  @override
  _CustomJoystickState createState() => _CustomJoystickState();
}

class _CustomJoystickState extends State<CustomJoystick> {
  @override
  Widget build(BuildContext context) {
    return Joystick(
      period: const Duration(milliseconds: 500),
      mode: JoystickMode.all,
      base: const JoystickBase(mode: JoystickMode.all),
      stickOffsetCalculator: const CircleStickOffsetCalculator(),
      listener: (details) {
        widget.listenerJoypadOnChange(details);
      },
    );
  }

}
