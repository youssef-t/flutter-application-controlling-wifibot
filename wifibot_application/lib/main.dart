
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      home: HomePage(),
      // TODO Define the routes
      // Start the app with the "/" named route. In this case, the app starts
      // on the Home widget.
      /*
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the Home widget.
        '/': (context) => HomeRoute(),
        // When navigating to the "/settings" route, build the SettingsRoute widget.
        '/settings': (context) => SettingsRoute(),
        // When navigating to the "/controller" route, build the ControllerRoute widget.
        '/controller': (context) => ControllerRoute(),
      },
      */
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const fontSizeButton = 30.0;


  static const textButtonStyle = TextStyle(
    fontSize: fontSizeButton,
  );

  @override
  Widget build(BuildContext context) {
    // Get the height and the width of the screen
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Wifibot Controller"),
        actions: [
          // TODO add a function to create a route for the settings page
          IconButton(onPressed: controllerButtonPushed, icon: Icon(Icons.settings, color: Colors.black,) )
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
          child: ElevatedButton(
            // TODO add a function to create a route for the controller page
            onPressed: controllerButtonPushed,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50), // double.infinity is the width and 50 is the height
            ),
            child: Text("Controller", style: textButtonStyle, ),

          ),
        ),
      ),
    );
  }
  // Flutter
  

  /// Load the controller page when the button "controller" is pushed
  void controllerButtonPushed() async{
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
      return ControllerRoute();
    }));
  }
}
