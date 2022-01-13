
/// Class that contains Wifibot constants: ip addresses and ports
class WifibotConstants {
  // TODO Change IP adress
  static const String wifiBotIPAddressDefault = "192.168.1.106";//"10.0.2.2";//"192.168.1.14";//"192.168.1.106";//"10.0.2.2";//"192.168.1.137";//
  static const String cameraIPAddressDefault = "192.168.1.106";
  // TODO Change port
  static const int tcpPortWifibotDefault = 15020;

  static const int udpPortWifibotCommandsDefault = 15000;
  static const int udpPortWifibotDataDefault = 15010;

  static const int cameraPortDefault = 8080;

  /// Timeout duration in seconds for TCP.
  static const int timeoutDurationTCPDefault = 10;

  // TODO Change interval
  /// The interval for sending the packet "data" in order to get information from wifibot
  static const int intervalMillisecondsForRequestingData = 2000;
}
