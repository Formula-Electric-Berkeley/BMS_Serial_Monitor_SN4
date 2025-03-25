import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serial_monitor/serial_monitor.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // SerialMonitor(SerialMonitor.availablePorts.last, 115200);

    print(SerialMonitor.availablePorts);
    SerialMonitor serialMonitor = SerialMonitor('/dev/cu.usbmodem2103', 115200);
    // serialMonitor.read();
    Timer(Duration(seconds: 2), () {
      print('Timer finished!');
      serialMonitor.close();
      print('Serial port closed!');

      print('New serial port opening');
      SerialMonitor serialMonitor2 = SerialMonitor('/dev/cu.usbmodem2103', 115200);
      print('New serial port opened');
      // serialMonitor2.read();
      Timer(Duration(seconds: 2), () {
        print('Timer finished!');
        serialMonitor2.close();
        print('Serial port closed');
      });
    });

    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
