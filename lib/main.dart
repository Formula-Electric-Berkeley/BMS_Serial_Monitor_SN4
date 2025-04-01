import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/info_table.dart';
import 'package:serial_monitor/serial_config.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final CarData carData = CarData();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      body: Column(
        children: [
          SerialConfig(carData),
          Center(child: InfoTable(carData))
        ]
      )
    ));
  }
}
