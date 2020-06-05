import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var forecastData;
  static const url = 'http://openweathermap.org/img/wn/03d@2x.png';
  int temperature = 0;
  var _isLoading = false;
  String statusUrl = url;
  String weather = 'clear';
  String location = 'Mumbai';
  var errorMessage = '';

  getData(String city) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var currentUrl =
          'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=92e07bd383eeb8e4e7e76fc8bde2126b&units=metric';
      var forecastUrl =
          'http://api.openweathermap.org/data/2.5/forecast?q=$city&appid=92e07bd383eeb8e4e7e76fc8bde2126b&units=metric';

      final response = await http.get(currentUrl);
      final result = json.decode(response.body)['main']['temp'];
      final place = json.decode(response.body)['name'];
      print(place);
      final description = json.decode(response.body)['weather'][0]['icon'];
      final state =
          json.decode(response.body)['weather'][0]['main'].toLowerCase();
      print(state);
      print(description);
      var imageUrl = 'http://openweathermap.org/img/wn/$description@2x.png';

      final forecastResponse = await http.get(forecastUrl);
      forecastData = json.decode(forecastResponse.body)['list'];

      setState(() {
        temperature = result.round();
        statusUrl = imageUrl;
        location = place;
        weather = state;
        errorMessage = '';
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Please enter appropriate city.';
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  final _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData('Mumbai');
  }

  void onTextFieldSubmitted(String input) {
    setState(() {
      _isLoading = true;
    });
    getData(input).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      'asset/image/$weather.jpg',
                      colorBlendMode: BlendMode.darken,
                      color: Colors.black26,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              labelText: 'Search City',
                              prefixIcon: Icon(Icons.search)),
                          onSubmitted: (String input) {
                            onTextFieldSubmitted(input);
                          },
                          controller: _inputController,
                        ),
                      ),
                      Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(
                        'Current Temperature',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      Center(child: Image.network(statusUrl)),
                      _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              '$temperature °C',
                              style:
                                  TextStyle(fontSize: 35, color: Colors.white),
                            ),
                      Text(
                        weather,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        location,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      )
                    ],
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                child: Column(
                  children: [
                    Text(
                      'Weather forecast for next 24 hours ',
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text(
                      'with data every 3 hours. ',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                color: Colors.black26,
                height: MediaQuery.of(context).size.height * 0.38,
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          var icon = forecastData[index]['weather'][0]['icon'];
                          var temp =
                              forecastData[index]['main']['temp'].round();
                          return ListTile(
                            title: Text(
                              forecastData[index]['dt_txt'].toString(),
                              style: Theme.of(context).textTheme.title,
                            ),
                            //subtitle: Text((forecastData[index]['weather'][0]['icon']),
                            trailing: Column(
                              children: [
                                Expanded(
                                    child: Image.network(
                                        'http://openweathermap.org/img/wn/$icon@2x.png')),
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : Text(
                                        '$temp °C',
                                        style:
                                            Theme.of(context).textTheme.title,
                                      ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.white,
                            ),
                        itemCount: 9)),
          ),
        ],
      ),
    );
  }
}
