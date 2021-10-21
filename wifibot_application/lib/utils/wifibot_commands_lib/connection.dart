
import 'package:wifibot_application/utils/wifibot_commands_lib/commands.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/data_wifibot.dart';

/// Manage the connection with the wifibot
class Connection{
  Connection();

  int? _rotationCameraX;
  int? _rotationCameraY;

  Commands? _command;
  DataWifibot? _dataWifibot;
  final int _timer = 100; //100ms


  void setSpeed(int speedLeft, int speedRight){ }

  void setAction() { }

}