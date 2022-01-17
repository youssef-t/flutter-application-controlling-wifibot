import 'dart:typed_data';
import 'dart:math';


/// Class to determine which data to send to send (=commands).
class CommandWifibot {
  // 2 last bytes for CRC
  static const int lengthCommand = 9;

  final Uint8List _commandPacket = Uint8List(lengthCommand);

  Uint8List get commandPacket => _commandPacket;

  static const int _upperLimitSpeed = 240;
  static int get upperLimitSpeed => _upperLimitSpeed;

  static const int _leftSpeedForwardFlag = 64;
  static const _leftSpeedBackwardFlag = 0;
  static const _rightSpeedForwardFlag = 16;
  static const _rightSpeedBackwardFlag = 0;

  CommandWifibot() {
    _commandPacket[0] = 255;
    _commandPacket[1] = 0x07;

    _setSpeed(0, 0);

    _updateCRC();
  }


  void _setRightSpeed(int rightSpeed) {
    if (rightSpeed > _upperLimitSpeed) {
      _commandPacket[2] = _upperLimitSpeed;
      print("WARNING - EXCEEDING RIGHT SPEED LIMIT");
    } else {
      _commandPacket[2] = rightSpeed;
    }
    _commandPacket[3] = 0;
  }

  void _setLeftSpeed(int leftSpeed) {
    if (leftSpeed > _upperLimitSpeed) {
      _commandPacket[4] = _upperLimitSpeed;
      print("WARNING - EXCEEDING LEFT SPEED LIMIT");
    } else {
      _commandPacket[4] = leftSpeed;
    }
    _commandPacket[5] = 0;
  }


  void _setSpeed(int rightSpeed, int leftSpeed) {

    _commandPacket[6] = 0;
    if(leftSpeed < 0) {
      leftSpeed *=-1;
      _commandPacket[6] += _leftSpeedBackwardFlag;
    }
    else {
      _commandPacket[6] += _leftSpeedForwardFlag;
    }

    if(rightSpeed < 0) {
      rightSpeed *=-1;
      _commandPacket[6] += _rightSpeedBackwardFlag;
    }
    else {
      _commandPacket[6] += _rightSpeedForwardFlag;
    }

    _setRightSpeed(rightSpeed);
    _setLeftSpeed(leftSpeed);
    _updateCRC();
  }

  /// Set right and left speeds given x and y. x and y are between -1 and 1 and they
  /// represent the coordinates of the joystick.
  void setSpeedFromXandY(double x, double y){
    // Polar coordinates:
    double radius = sqrt(x*x + y*y);
    double theta = atan2(y, x);

    double rightSpeedNotNormalized = 0.0;
    double leftSpeedNotNormalized = 0.0;

    // In case we use a square instead of a circle (radius can be higher than 1)
    if(radius > 1) {
      radius = 1;
    }

    if( y > 0) {
      if (x > 0) {
        rightSpeedNotNormalized = radius*sin(theta).abs();
        leftSpeedNotNormalized = radius;
      }
      else {
        rightSpeedNotNormalized = radius;
        leftSpeedNotNormalized = (radius*sin(theta)).abs();
      }
    }
    // if y < 0, we want right and left speeds to be negative
    else {
      if (x > 0) {
        rightSpeedNotNormalized = - radius*sin(theta).abs();
        leftSpeedNotNormalized = - radius;
      }
      else {
        rightSpeedNotNormalized = - radius;
        leftSpeedNotNormalized = - (radius*sin(theta)).abs();
      }
    }

    // Normalize the speeds
    int rightSpeed = (rightSpeedNotNormalized * upperLimitSpeed).round();
    int leftSpeed = (leftSpeedNotNormalized * upperLimitSpeed).round();
    print("rightSpeed: $rightSpeed");
    print("leftSpeed: $leftSpeed");
    _setSpeed(rightSpeed, leftSpeed);
  }

  /// Calculate CRC to add it to the command
  void _updateCRC() {
    int crc = 0xFFFF;
    int polynome = 0xA001;
    int cptOctet = 0;
    int cptBit = 0;
    int parity = 0;

    // For loop in the part containing the command (not CRC)
    for (cptOctet = 0; cptOctet < lengthCommand - 3; cptOctet++) {
      // Exclusive OR between the message and the crc
      crc ^= _commandPacket.elementAt(1 + cptOctet);

      for (cptBit = 0; cptBit <= 7; cptBit++) {
        parity = crc;
        crc >>= 1; // Décalage a droite du crc
        if (parity % 2 == 1) {
          crc ^= polynome;
        }
      }
    }

    _commandPacket[lengthCommand-2] = crc & 0x00FF;
    _commandPacket[lengthCommand-1] = crc >> 8;
  }

}
