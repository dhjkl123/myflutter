import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<String> locations = [
    "구로구",
    "동작구",
    "마포구",
    "강남구",
    "강동구",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          for (var location in locations)
            ListTile(
              title: Text(location),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop(location);
              },
            )
        ],
      ),
    );
  }
}
