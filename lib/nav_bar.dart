import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/serial_config.dart';

class SerialNavBar extends StatelessWidget {
  final CarData carData;

  const SerialNavBar(this.carData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: SerialConfig(carData)
    );
  }
}