import 'dart:ffi';
import 'dart:typed_data';

/// Enum [Direction] tells the robot which direction to go to.
enum Direction {
  forward,
  backward,
  clockwise,
  anticlockwise,
}

/// Class to determine which data to send to send (=commands).
class Commands {
  static const int lengthCommandTCP = 7;

  // 2 bytes for CRC
  static const int lengthCommandUDP = 9;

  final Uint8List _commandPacket = Uint8List(lengthCommandUDP);

  Uint8List get commandPacket => _commandPacket;

  static const int _upperLimitSpeed = 240;

  Commands() {
    _commandPacket[0] = 255;
    _commandPacket[1] = lengthCommandTCP;

    setRightSpeed(10);
    setLeftSpeed(10);
    setDirection(Direction.forward);


    // TODO UPDATE CRC IN CASE WE USE UDP - AND THE LIBRARY ONLY SUPPORTS TCP
  }

  /// Change
  void setAction(int rightSpeed, int leftSpeed, Direction dir) {
    setRightSpeed(rightSpeed);
    setLeftSpeed(leftSpeed);
    setDirection(dir);
  }

  void setRightSpeed(int rightSpeed) {
    if (rightSpeed > _upperLimitSpeed) {
      _commandPacket[2] = _upperLimitSpeed;
      print("WARNING - EXCEEDING RIGHT SPEED LIMIT");
    } else {
      _commandPacket[2] = rightSpeed;
    }
    _commandPacket[3] = 0;
  }

  void setLeftSpeed(int leftSpeed) {
    if (leftSpeed > _upperLimitSpeed) {
      _commandPacket[4] = _upperLimitSpeed;
      print("WARNING - EXCEEDING LEFT SPEED LIMIT");
    } else {
      _commandPacket[4] = leftSpeed;
    }
    _commandPacket[5] = 0;
  }

  void setDirection(Direction dir) {
    switch (dir) {
      case Direction.forward:
        _commandPacket[6] = 80;
        break;
      case Direction.backward:
        _commandPacket[6] = 2;
        break;
      case Direction.anticlockwise:
        _commandPacket[6] = 62;
        break;
      case Direction.clockwise:
        _commandPacket[6] = 66;
        break;
    }
  }

  /// Calculate CRC to add it to the command to send for UDP
  void updateCRC() {
    int crc = 0xFFFF;
    int polynome = 0xA001;
    int cptOctet = 0;
    int cptBit = 0;
    int parity = 0;

    // For loop in the part containing the command (not CRC)
    for (cptOctet = 0; cptOctet < lengthCommandUDP - 3; cptOctet++) {
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

    _commandPacket[lengthCommandUDP-2] = crc & 0x00FF;
    _commandPacket[lengthCommandUDP-1] = crc >> 8;

  }
}
