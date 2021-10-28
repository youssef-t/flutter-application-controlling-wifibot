// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

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

    print("screenHeight : $screenHeight");
    print("screenWidth: $screenWidth");

    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Wifibot Controller",
        ),
        ),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.settings, color: Colors.black,) )
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50), // double.infinity is the width and 30 is the height
            ),
            child: Text("Controller", style: textButtonStyle, ),


          ),
        ),
      ),
    );
  }
}
