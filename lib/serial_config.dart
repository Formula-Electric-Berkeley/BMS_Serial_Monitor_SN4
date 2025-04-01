import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';

class SerialConfig extends StatefulWidget {
  final CarData carData;

  const SerialConfig(this.carData, {super.key});

  @override
  State<SerialConfig> createState() => _SerialConfigState();
}

class _SerialConfigState extends State<SerialConfig> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}