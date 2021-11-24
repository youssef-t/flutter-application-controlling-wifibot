import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifibot_application/routes/controller_route.dart';
import 'package:wifibot_application/routes/home_route.dart';
import 'package:wifibot_application/routes/settings_route.dart';
import 'package:wifibot_application/routes/test_communication.dart';
import 'package:wifibot_application/utils/orientation_helpers.dart';

// Class that defines the routes with their corresponding path
class AppRoutes {
  static const home = '/';
  static const settings = '/settings';
  static const controller = '/controller';
}

// TODO Correcting the display with SystemChrome.setEnabledSystemUIMode
// Class that defines the routes of the app.
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
            overlays: []);
        return MaterialPageRoute(
          builder: (_) => TestCommunication(),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case AppRoutes.settings:
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
            overlays: []);
        return MaterialPageRoute(
          builder: (_) => SettingsRoute(),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case AppRoutes.controller:
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
            overlays: []);
        return MaterialPageRoute(
          builder: (_) => ControllerRoute(),
          settings: rotationSettings(settings, ScreenOrientation.landscapeOnly),
        );

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => HomeRoute());
    }
  }
}

/// Setting the arguments of the route
RouteSettings rotationSettings(
    RouteSettings settings, ScreenOrientation rotation) {
  return RouteSettings(name: settings.name, arguments: rotation);
}
