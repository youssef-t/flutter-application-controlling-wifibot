
import 'dart:typed_data';

/// Class used to read the data sent by the wifibot
class DataWifibot{

  // The robot sends packets with 21 characters
  static const int lengthRawDataPacket = 21;
  /// Variable to store the packet with 21 characters
  Uint8List _rawDataPacket = Uint8List(lengthRawDataPacket);
  Uint8List get rawDataPacket => _rawDataPacket;

  /// Variable to verify the length of the data packet
  int _lengthRawDataPacketReceived = 0;

  /// Variable to store all the data related to the state of the robot
  var _dataWifibotMap = Map();
  get dataWifibotMap => _dataWifibotMap;

  /// Default constructor
  DataWifibot.withoutRawDataPacket();

  /// Constructor with a parameter as the raw data packet as Uint8List
  DataWifibot(this._rawDataPacket){
    _lengthRawDataPacketReceived = _rawDataPacket.length;
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

  /// Constructor with a parameter as a the raw data packet as a String
  DataWifibot.withRawDataPacketString(String rawDataPacket){
    // codeUnits gets you a List<int>
    // Uint8List.fromList(...) converts List<int> to Uint8List
    DataWifibot(Uint8List.fromList(rawDataPacket.codeUnits));
  }

  set rawDataPacket(Uint8List dataPacket) {
    _rawDataPacket = dataPacket;
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


  double? getRightSpeed() {
    if (!_isDataValid()) return null;
    int rightSpeed = (_rawDataPacket[10] << 8) + rawDataPacket[9];
    if(rightSpeed > 32767) {
      rightSpeed -= 65536;
    }
    return rightSpeed*100.0/400.0;
  }

  double? getLeftSpeed() {
    if (!_isDataValid()) return null;
    int leftSpeed = (_rawDataPacket[1] << 8) + rawDataPacket[0];
    if(leftSpeed > 32767) {
      leftSpeed -= 65536;
    }
    return leftSpeed*100.0/400.0;
  }
  int? getBattery() => !_isDataValid() ? null:rawDataPacket[2];
  int? getIR_LF() => !_isDataValid() ? null:rawDataPacket[3];
  int? getIR_LB() => !_isDataValid() ? null:rawDataPacket[4];
  int? getIR_RF() => !_isDataValid() ? null:rawDataPacket[12];
  int? getIR_RB() => !_isDataValid() ? null:rawDataPacket[11];

  int? getOdometryL() => !_isDataValid() ? null:(rawDataPacket[8] << 24)+(rawDataPacket[7] << 16)
      +(rawDataPacket[6] << 8)+rawDataPacket[5];
  int? getOdometryR() => !_isDataValid() ? null:(rawDataPacket[16] << 24)+(rawDataPacket[15] << 16)
      +(rawDataPacket[14] << 8)+rawDataPacket[13];

  void showData() {
    print("leftSpeed: ${getLeftSpeed()}");
    print("rightSpeed: ${getRightSpeed()}");
    print("Batterie: ${getBattery()}");
    print("LB: ${getIR_LB()} ");
    print("LF: ${getIR_LF()}");
    print("RB: ${getIR_RB()}");
    print("RF: ${getIR_RF()}");
  }

  /// Verify if the data are in a valid format
  bool _isDataValid() => _lengthRawDataPacketReceived==lengthRawDataPacket ? true : false;
}