
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifibot_application/route_generator.dart';
import 'package:wifibot_application/routes/controller_route.dart';
import 'package:wifibot_application/routes/home_route.dart';
import 'package:wifibot_application/routes/settings_route.dart';


// Variable to store the width of the screen
double? screenWidth;
// Variable to store the height of the screen
double? screenHeight;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Wifibot Controller',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      // Start the app with the "/" named route. In this case, the app starts
      // on the Home widget.
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,

    );
  }
}

