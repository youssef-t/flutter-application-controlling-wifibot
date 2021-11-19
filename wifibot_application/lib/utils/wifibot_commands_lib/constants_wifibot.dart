
/// Class that contains Wifibot constants: ip addresses and ports
class WifibotConstants {
  static const String wifiBotIPAddressDefault = "192.168.1.106";
  static const String cameraIPAddressDefault = "192.168.1.106";

  static const int tcpPortWifibot = 15020;

  static const int udpPortWifibotSendCommand = 15000;
  static const int udpPortWifibotReceiveData = 15010;

  static const int cameraPort = 8080;

  /// Timeout duration in seconds for TCP.
  static const int timeoutDurationTCPDefault = 10;
}
