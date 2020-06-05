import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/homePage.dart';

//import 'package:flare_dart/actor.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration(
          seconds: 7,
        ), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // crossAxisAlignment: CrossAxisAlignment.,

          Container(
        height: double.infinity,
        width: double.infinity,
        child: FlareActor(
          'asset/image/SplashScreen.flr',
          animation: 'dark',
          fit: BoxFit.cover,
        ),
      ),
      
    );
  }
}
