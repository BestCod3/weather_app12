import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/constants/apiKeys/apiKey.dart';
import 'package:weather_app/pages/searchPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String cityName = '';
  String country = '';
  dynamic tempreture;
  bool isLoading = false;

  @override
  void initState() {
    showWeatherByLocation();
    super.initState();
  }

  // double checkDouble(dynamic value) {
  //   if (value is String) {
  //     return double.parse(value);
  //   } else {
  //     return value;
  //   }
  // }

  Future<void> showWeatherByLocation() async {
    setState(() {
      isLoading = true;
    });
    final position = await _getPosition();
    await getWeather(position);

    // log("latitude ==> ${position.latitude}");
    // log("longitude ==> ${position.longitude}");
  }

  Future<void> getWeather(Position position) async {
    try {
      final client = http.Client();

      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=${ApiKeys.MyApiKey}';
      Uri uri = Uri.parse(url);
      final result = await client.get(uri);
      final jsonResult = jsonDecode(result.body);
      cityName = jsonResult['name'];
      tempreture = jsonResult['main']['temp'];
      country = jsonResult['sys']['country'];
      final double kelvin = jsonResult['main']['temp'];
      tempreture = (kelvin - 273.15).toStringAsFixed(0);
      // checkDouble(tempereture);
      log('response ===> ${jsonResult['name']}');
      setState(() {
        isLoading = false;
      });

      // log('response ==> ${result.body}');
      // log('response json ==> ${jsonResult}');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> getSearchedCityName(dynamic typedCityName) async {
    final client = http.Client();
    try {
      Uri uri = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$typedCityName&appid=${ApiKeys.MyApiKey}');
      final response = await client.get(uri);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        log("data ===> $data");
        cityName = data["name"];
        country = data['sys']['country'];
        final double kelvin = data['main']['temp'];
        tempreture = (kelvin - 273.15).toStringAsFixed(0);
        setState(() {});
      }
    } catch (e) {}
  }

  Future<Position> _getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true, //- прозрачность шапки!
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () async {
              await showWeatherByLocation();
            },
            child: Icon(
              Icons.near_me,
              size: 45,
            ),
          ),
          actions: [
            InkWell(
              onTap: () async {
                final typedCityName = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
                await getSearchedCityName(typedCityName);
                setState(() {});
              },
              child: Icon(
                Icons.location_city,
                size: 45,
              ),
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/sea.jpg'), fit: BoxFit.cover),
          ),
          child: Center(
            child: isLoading == true
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Stack(
                    children: [
                      Positioned(
                        top: 100,
                        left: 130,
                        child: Text(
                          '⛅',
                          style: TextStyle(fontSize: 60, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        top: 70,
                        left: 40,
                        child: Text(
                          'Country: $country',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        top: 130,
                        left: 40,
                        child: Text(
                          '$tempreture\u2103',
                          style: TextStyle(fontSize: 50, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        top: 330,
                        left: 120,
                        child: Text(
                          'Very cold',
                          style: TextStyle(fontSize: 60, color: Colors.white),
                        ),
                        //try как приходить информация находит ошибки итд.
                        //initstate до скаффолда
                        //json formatter
                      ),
                      Positioned(
                        top: 530,
                        left: 70,
                        child: Text(
                          cityName,
                          style: TextStyle(fontSize: 50, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
