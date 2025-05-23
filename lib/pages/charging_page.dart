import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:serial_monitor/charging/info_line_chart.dart';
import 'package:serial_monitor/globals.dart' as globals;
import 'package:serial_monitor/info_table/info_table_charging.dart';

class ChargingPage extends StatelessWidget {
  const ChargingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 30,
      children: [
        SizedBox(),
        Row(
          spacing: 50,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [InfoTableChargingRequest(), InfoTableChargingOutput()],
        ),
        InfoTableChargingFlags(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 90,
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
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.deepOrangeAccent,
                  cutOffY: 0,
                  applyCutOffY: true,
                ),
                aboveBarData: BarAreaData(
                  show: true,
                  color: Colors.lightGreenAccent,
                  cutOffY: 0,
                  applyCutOffY: true,
                ),
              ),
            ),
          ],
        ),
        SizedBox(),
      ],
    );
  }
}
