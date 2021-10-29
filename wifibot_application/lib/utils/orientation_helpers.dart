
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// Enum that represents possible screen orientations.
enum ScreenOrientation {
  portraitOnly,
  landscapeOnly,
  rotating,
}

/// Function to rotate the screen depending on the argument [orientation]
///
/// [isPortraitDownSupported] is useful for tablets and it's set by default to false
void setOrientation(Object? orientation, {bool isPortraitDownSupported = false}) {
  // The default orientation is portraitUp
  List<DeviceOrientation> orientations = [
    DeviceOrientation.portraitUp
  ];
  // Different possible orientations depending on the orientation parameter
  switch (orientation) {
    case ScreenOrientation.portraitOnly:
      orientations = [
        DeviceOrientation.portraitUp,
        if(isPortraitDownSupported) DeviceOrientation.portraitDown,
      ];
      break;
    case ScreenOrientation.landscapeOnly:
      orientations = [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
      break;
    case ScreenOrientation.rotating:
      orientations = [
        DeviceOrientation.portraitUp,
        if(isPortraitDownSupported) DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
      break;
  }
  // Setting the screen orientation
  SystemChrome.setPreferredOrientations(orientations);
}

class NavigatorObserverWithOrientation extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute?.settings.arguments is ScreenOrientation) {
      setOrientation(previousRoute?.settings.arguments);
    } else {
      // Portrait-only is the default option
      setOrientation(ScreenOrientation.portraitOnly);
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings.arguments is ScreenOrientation) {
      setOrientation(route.settings.arguments);
    } else {
      setOrientation(ScreenOrientation.portraitOnly);
    }
  }
}