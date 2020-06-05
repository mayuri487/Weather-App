
import 'package:flutter/material.dart';
import 'package:weather_app/firstScree.dart';
import 'package:weather_app/homePage.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: Colors.black12,
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
            
          )
        )
      ),
        home: FirstPage(),
        routes: {
          '/homepage': (context) => MyHomePage()
        },
    );
  }
}
