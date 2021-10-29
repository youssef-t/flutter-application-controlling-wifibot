
import 'package:flutter/material.dart';
import 'package:wifibot_application/routes/controller_route.dart';
import 'package:wifibot_application/routes/home_route.dart';
import 'package:wifibot_application/routes/settings_route.dart';
import 'package:wifibot_application/utils/orientation_helpers.dart';

// Class that defines the routes with their corresponding path
class AppRoutes {
  static const home = '/';
  static const settings = '/settings';
  static const controller = '/controller';
}

// Class that defines the routes of the app.
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
            builder: (_) => HomeRoute(),
          settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
        );
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => SettingsRoute(),
            settings: rotationSettings(settings, ScreenOrientation.portraitOnly),
    );
      case AppRoutes.controller:
        return MaterialPageRoute(builder: (_) => ControllerRoute(),
            settings: rotationSettings(settings, ScreenOrientation.landscapeOnly),
    );

      default:
      // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => HomeRoute());
    }
  }

}

RouteSettings rotationSettings(RouteSettings settings, ScreenOrientation rotation) {
  return RouteSettings(name: settings.name, arguments: rotation);
}