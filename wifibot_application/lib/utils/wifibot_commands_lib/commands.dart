
import 'dart:typed_data';

enum direction {
  FORWARD,
  BACKWARD,
  CLOCKIWISE,
  ANTICLOCKWISE,
}

/// Class to change the parameters of the data to send (=commands)
class Commands{

  static const int lengthCommandTCP = 7;
  // 2 bytes for CRC
  static const int lengthCommandUDP = 9;
  final Uint8List _commandPacket = Uint8List(lengthCommandTCP);

  static const int _upperLimitSpeed = 240;

  Commands() {
    _commandPacket[0] = 255;
    _commandPacket[1] = lengthCommandTCP;

    // TODO UPDATE CRC IN CASE WE USE UDP
  }

  void setAction(int rightSpeed, int leftSpeed, direction dir){
    setRightSpeed(rightSpeed);
    setLeftSpeed(leftSpeed);
    setDirection(dir);
  }

  void setRightSpeed(int rightSpeed){

    if(rightSpeed > _upperLimitSpeed){
      _commandPacket[2] = _upperLimitSpeed;
      print("WARNING - EXCEEDING RIGHT SPEED LIMIT");
    } else {
      _commandPacket[2] = rightSpeed;
    }
    _commandPacket[3] = 0;

  }

  void setLeftSpeed(int leftSpeed){
    if(leftSpeed > _upperLimitSpeed){
      _commandPacket[4] = _upperLimitSpeed;
      print("WARNING - EXCEEDING LEFT SPEED LIMIT");
    } else {
      _commandPacket[4] = leftSpeed;
    }
    _commandPacket[5] = 0;
  }

  void setDirection(direction dir){
    switch(dir){
      case direction.FORWARD:
        _commandPacket[6] = 80;
        break;
      case direction.BACKWARD:
        _commandPacket[6] = 2;
        break;
      case direction.ANTICLOCKWISE:
        _commandPacket[6] = 62;
        break;
      case direction.CLOCKIWISE:
        _commandPacket[6] = 80;
        break;
    }
  }

}