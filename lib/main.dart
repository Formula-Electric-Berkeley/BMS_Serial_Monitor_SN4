import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/info_table.dart';
import 'package:serial_monitor/serial_config.dart';
import 'package:serial_monitor/serial_monitor.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final CarData carData = CarData();
  late final SerialMonitor serialMonitor;

  MainApp({super.key}) {
    serialMonitor = SerialMonitor(
      SerialMonitor.availablePorts.last,
      115200,
      carData,
    );
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(home: Scaffold(body: Center(child: InfoTable(carData))));
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
