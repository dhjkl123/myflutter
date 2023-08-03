import 'package:cloth/data/weather.dart';
import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<LocationData> locations = [
    LocationData("강남구", 0, 0, 37.498122, 127.027565),
    LocationData("동작구", 0, 0, 37.502418, 127.953647),
    LocationData("마포구", 0, 0, 37.560502, 127.907612),
    LocationData("성동구", 0, 0, 37.556723, 127.035401),
    LocationData("강동구", 0, 0, 37.552288, 127.145225),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          for (var loc in locations)
            ListTile(
              title: Text(loc.name),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop(loc);
              },
            )
        ]),
      ),
    );
  }
}
