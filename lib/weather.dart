import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tutorial/forcastCard.dart';
import 'package:tutorial/secrets.dart';

class MyWeatherApp extends StatefulWidget {
  const MyWeatherApp({super.key});

  @override
  State<MyWeatherApp> createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> {
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getWeather() async {
    try {
      String place = 'London';
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$place&APPID=$WEATHER_API_KEY'));

      // convert response to json
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw data['message'];
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: GoogleFonts.raleway(
              textStyle: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  weather = getWeather();
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          // loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          // error state
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }

          // grab the data from response
          final data = snapshot.data!;

          // current data
          final currentData = data['list'][0];
          final currentTemp = currentData['main']['temp'];
          final weather = currentData['weather'][0]['main'];
          final pressure = currentData['main']['pressure'];
          final windSpeed = currentData['wind']['speed'];
          final humindity = currentData['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '$currentTemp K',
                            style: GoogleFonts.raleway(
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Icon(
                            weather == "Clouds" || weather == "Rain"
                                ? Icons.cloud
                                : Icons.sunny,
                            size: 65,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            weather,
                            style: GoogleFonts.raleway(
                                textStyle: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Hourly Forcast",
                  style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 115,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final hourlyWeather =
                          hourlyForecast['weather'][0]['main'];
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      final hourlyTemp =
                          hourlyForecast['main']['temp'].toString();
                      return ForcastCard(
                          temperature: hourlyTemp,
                          icon: hourlyWeather == "Clouds" ||
                                  hourlyWeather == "Rain"
                              ? Icons.cloud
                              : Icons.sunny,
                          time: DateFormat.j().format(time));
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Additional Information",
                  style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionalInfoItem(
                        icon: Icons.water_drop,
                        lable: "humidity",
                        value: humindity.toString()),
                    AdditionalInfoItem(
                        icon: Icons.air,
                        lable: "Wind Speed",
                        value: windSpeed.toString()),
                    AdditionalInfoItem(
                        icon: Icons.beach_access,
                        lable: "Pressure",
                        value: pressure.toString()),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// addintional info item
class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String lable;
  final String value;
  const AdditionalInfoItem(
      {super.key,
      required this.icon,
      required this.lable,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 35,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(lable,
            style:
                GoogleFonts.raleway(textStyle: const TextStyle(fontSize: 16))),
        const SizedBox(
          height: 5,
        ),
        Text(value,
            style: GoogleFonts.raleway(
                textStyle:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
            // style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
      ],
    );
  }
}
