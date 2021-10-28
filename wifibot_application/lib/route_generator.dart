
import 'package:flutter/material.dart';
import 'package:wifibot_application/routes/controller_route.dart';
import 'package:wifibot_application/routes/home_route.dart';
import 'package:wifibot_application/routes/settings_route.dart';

// Class that defines the routes of the app
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeRoute());
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsRoute());
      case '/controller':
        return MaterialPageRoute(builder: (_) => ControllerRoute());

      default:
      // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => HomeRoute());
    }
  }

}