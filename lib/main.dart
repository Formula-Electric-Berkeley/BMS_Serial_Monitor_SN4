import 'package:flutter/material.dart';
import 'package:serial_monitor/serial_monitor.dart';
import 'info_table.dart';
import 'car_data.dart';

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
    return MaterialApp(home: Scaffold(body: Center(child: InfoTable(carData))));
  }
}
