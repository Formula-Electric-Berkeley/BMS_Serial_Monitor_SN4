import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/info_table.dart';
import 'package:serial_monitor/nav_bar.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final CarData carData = CarData();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: Scaffold(
        body: Column(
          children: [
            SerialNavBar(carData),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [InfoTable(carData)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
