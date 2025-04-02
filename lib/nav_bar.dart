import 'package:flutter/material.dart';
import 'package:serial_monitor/app_settings.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/serial_config.dart';

class NavBar extends StatelessWidget {
  final CarData carData;

  const NavBar(this.carData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SerialConfig(carData),
          TextButton.icon(
            label: Text('Clear Data'),
            icon: Icon(Icons.clear_sharp),
            onPressed: carData.clear,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(),
            ),
          ),
          TextButton.icon(
            label: Text('Settings'),
            icon: Icon(Icons.settings),
            onPressed: showSettings(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
