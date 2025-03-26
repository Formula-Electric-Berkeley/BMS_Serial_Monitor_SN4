import 'dart:async';

import 'package:flutter/material.dart';
import 'info_table.dart';
import 'car_data.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final CarData carData = CarData();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Remove following line
    Timer.periodic(Duration(milliseconds: 1000), randomizeData(carData));
    return MaterialApp(home: Scaffold(body: Center(child: InfoTable(carData))));
  }
}
