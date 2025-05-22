import 'package:flutter/material.dart';
import 'package:serial_monitor/charging/info_line_chart.dart';

import 'package:serial_monitor/globals.dart' as globals;

class ChargingPage extends StatelessWidget {
  const ChargingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 50,
          children: [
            SizedBox(
              width: 400,
              height: 400,
              child: InfoLineChart(
                nextValue: () => globals.carData.packData.totalVoltage,
                numSeconds: 30,
                yLabel: 'Total Voltage / V',
              ),
            ),
            SizedBox(
              width: 400,
              height: 400,
              child: InfoLineChart(
                nextValue: () => globals.carData.ivtData.current,
                numSeconds: 30,
                yLabel: 'Total Current / A',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
