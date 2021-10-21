
import 'dart:typed_data';

/// Class used to read the data sent by the wifibot
class DataWifibot{

  // The robot sends packets with 21 characters
  static const int lengthRawDataPacket = 21;
  /// Variable to store the packet with 21 characters
  Uint8List _rawDataPacket = Uint8List(lengthRawDataPacket);
  /// Variable to store all the data related to the state of the robot
  var _dataWifibotMap = Map();

  // Default constructor

  DataWifibot.withoutRawDataPacket();
  DataWifibot(this._rawDataPacket){
    _dataWifibotMap = {
      'left_speed': getLeftSpeed(),
      'right_speed': getRightSpeed(),
      'battery': getBattery(),
      'getIR_LF': getIR_LF(),
      'getIR_LB': getIR_LB(),
      'getIR_RF': getIR_RF(),
      'getIR_RB': getIR_RB()
    };
  }

  Uint8List get rawDataPacket => _rawDataPacket;

  set rawDataPacket(Uint8List value) {
    _rawDataPacket = value;
    _dataWifibotMap = {
      'left_speed': getLeftSpeed(),
      'right_speed': getRightSpeed(),
      'battery': getBattery(),
      'getIR_LF': getIR_LF(),
      'getIR_LB': getIR_LB(),
      'getIR_RF': getIR_RF(),
      'getIR_RB': getIR_RB()
    };
  }



  double getRightSpeed() {
    int rightSpeed = (_rawDataPacket[10] << 8) + rawDataPacket[9];
    if(rightSpeed > 32767) {
      rightSpeed -= 65536;
    }
    return rightSpeed*100.0/400.0;
  }

  double getLeftSpeed() {
    int leftSpeed = (_rawDataPacket[1] << 8) + rawDataPacket[0];
    if(leftSpeed > 32767) {
      leftSpeed -= 65536;
    }
    return leftSpeed*100.0/400.0;
  }
  int getBattery() => rawDataPacket[2];
  int getIR_LF() => rawDataPacket[3];
  int getIR_LB() => rawDataPacket[4];
  int getIR_RF() => rawDataPacket[12];
  int getIR_RB() => rawDataPacket[11];

  int getOdometryL() => (rawDataPacket[8] << 24)+(rawDataPacket[7] << 16)
      +(rawDataPacket[6] << 8)+rawDataPacket[5];
  int getOdometryR() => (rawDataPacket[16] << 24)+(rawDataPacket[15] << 16)
      +(rawDataPacket[14] << 8)+rawDataPacket[13];

  void showData() {
    print("Batterie: $getBattery()");
    print("LB: ${getIR_LB()} ");
    print("LF: ${getIR_LF()}");
    print("RB: ${getIR_RB()}");
    print("RF: ${getIR_RF()}");
  }
}