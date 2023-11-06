import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isloading = false;
  bool gettingLocation = false;
  bool showlocations = false;
  static String apiKey = "0ab2d890521944e28aa135817230511";
  double temp = 0;
  double windspeed = 0;
  double humidity = 0;
  double cloud = 0;
  String currentDate = "";
  String weatherIcon = "";
  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];
  String currentWaetherStatus = "";
  String location = "London";
  String showlocation = "";
  String searchAPIkey = "https://api.weatherapi.com/v1/forecast.json?key=" +
      apiKey +
      "&days=7&q=";
  void fetchWeather(String location) async {
    try {
      setState(() {
        isloading = true;
      });
      var res = await http.get(Uri.parse(searchAPIkey + location));
      setState(() {
        isloading = false;
      });
      final data =
          Map<String, dynamic>.from(json.decode(res.body ?? "No Data"));
      setState(() {
        temp = data["current"]["temp_c"].toDouble();
        windspeed = data["current"]["wind_kph"].toDouble();
        humidity = data["current"]["humidity"].toDouble();
        cloud = data["current"]["cloud"].toDouble();
        currentDate = data["location"]["localtime"];
        hourlyWeatherForecast = data["forecast"]["forecastday"][0]["hour"];
        dailyWeatherForecast = data["forecast"]["forecastday"];
        currentWaetherStatus = data["current"]["condition"]["text"];
      });

      var locationdata = data["location"];
      var currentWeather = data["current"];
      setState(() {
        location = locationdata["name"];
        showlocation = locationdata["name"];
        print(location);
        var parseddate = DateTime.parse(currentDate.substring(0, 10));
        var newDate = DateFormat().add_yMMMMEEEEd().format(parseddate);
        currentDate = newDate;
        currentWaetherStatus = currentWeather["condition"]["text"];
        weatherIcon = currentWaetherStatus.replaceAll(" ", "").toLowerCase();
        temp = currentWeather["temp_c"].toDouble();
        log(dailyWeatherForecast.toString());
      });
    } catch (e) {
      print(e);
    }
  }

  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkConnectivity();

    getCurrentCity();
    fetchWeather(location);
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
      });
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = connectivityResult;
    });
  }

  Future<String> getCurrentCity() async {
    try {
      setState(() {
        gettingLocation = true;
        showlocations = false;
      });
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String? city = placemarks[0].locality;
      setState(() {
        gettingLocation = false;
        showlocations = true;
      });
      fetchWeather(city ?? "Jaipur");
      print(city);
      return city ?? "No Data";
    } catch (e) {
      return "No Data";
    }
  }

  static String getShortLocationName(String name) {
    List<String> words = name.split(" ");
    if (words.isNotEmpty) {
      if (words.length > 1) {
        return words[0] + " " + words[1];
      } else {
        return words[0];
      }
    } else {
      return " ";
    }
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String connectivityStatus = 'Unknown';
    if (_connectivityResult == ConnectivityResult.mobile) {
      connectivityStatus = 'Connected';
    } else if (_connectivityResult == ConnectivityResult.wifi) {
      connectivityStatus = 'Connected';
    } else if (_connectivityResult == ConnectivityResult.bluetooth) {
      connectivityStatus = 'Connected';
    } else if (_connectivityResult == ConnectivityResult.ethernet) {
      connectivityStatus = 'Connected';
    } else if (_connectivityResult == ConnectivityResult.none) {
      connectivityStatus = 'No connectivity';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        actions: [
          Text(FirebaseAuth.instance.currentUser!.email!),
          IconButton(
            onPressed: () {
              fetchWeather(location);
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Current Weather",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        "Network Status: $connectivityStatus",
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Enter Location",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                      onPressed: () {
                        fetchWeather(location);
                      },
                      icon: Icon(Icons.search),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      location = value;
                      fetchWeather(location);
                    });
                  },
                ),
              ),
              if (showlocations == false) ...{
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    showlocation,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              } else ...{
                SizedBox.shrink()
              },
              if (gettingLocation == true) ...{
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Getting Current Location",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              } else ...{
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    showlocation,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              },
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Hourly Weather Forecast for Current Day",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    DateTime parsedDateTime = DateFormat("yyyy-MM-dd HH:mm")
                        .parse('${hourlyWeatherForecast[index]["time"]}');
                    print(parsedDateTime);

                    String formattedTime =
                        DateFormat('HH:mm a').format(parsedDateTime);
                    if (isloading) {
                      return Container(
                        height: 200,
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              Text("Loading..."),
                            ],
                          ),
                        ),
                      );
                    } else {
                      double temperatureCelsius =
                          hourlyWeatherForecast[index]["temp_c"].toDouble();
                      return Container(
                          height: 200,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: temperatureCelsius > 30
                                      ? LinearGradient(
                                          colors: [Colors.yellow, Colors.red])
                                      : LinearGradient(
                                          colors: [Colors.blue, Colors.white]),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Time: $formattedTime",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                          "Temperature: ${temperatureCelsius}°C",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text(
                                          "Wind Speed: ${hourlyWeatherForecast[index]["wind_kph"]} km/h",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text(
                                          "Humidity: ${hourlyWeatherForecast[index]["humidity"]}%",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text(
                                          "Cloud: ${hourlyWeatherForecast[index]["cloud"]}%",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                ),
                              )));
                    }
                  },
                  itemCount: hourlyWeatherForecast.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Daily Weather Forecast",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    DateTime parsedDate = DateFormat('yyyy-MM-dd')
                        .parse(dailyWeatherForecast[index]["date"]);

                    String formattedDate =
                        DateFormat('MMM d, yyyy').format(parsedDate);
                    if (isloading) {
                      return Container(
                        height: 200,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            Text("Loading..."),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              gradient: dailyWeatherForecast[index]["day"]
                                              ["avgtemp_c"]
                                          .toInt() >
                                      30
                                  ? LinearGradient(
                                      colors: [Colors.yellow, Colors.red])
                                  : LinearGradient(
                                      colors: [Colors.blue, Colors.white]),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${dailyWeatherForecast[index]["day"]["avgtemp_c"].toInt()}°C",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${dailyWeatherForecast[index]["day"]["condition"]["text"]}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Image.network(
                                    "https:${dailyWeatherForecast[index]["day"]["condition"]["icon"]}",
                                    height: 50,
                                    width: 50,
                                  ),
                                  Text(
                                    "Max: ${dailyWeatherForecast[index]["day"]["maxtemp_c"].toInt()}°C",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Min: ${dailyWeatherForecast[index]["day"]["mintemp_c"].toInt()}°C",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Wind Speed: ${dailyWeatherForecast[index]["day"]["maxwind_kph"].toInt()} km/h",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Humidity: ${dailyWeatherForecast[index]["day"]["avghumidity"].toInt()}%",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Cloud: ${dailyWeatherForecast[index]["day"]["daily_chance_of_rain"].toInt()}%",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  itemCount: dailyWeatherForecast.length,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getCurrentCity();
        },
        child: Icon(Icons.location_on),
      ),
    );
  }
}
