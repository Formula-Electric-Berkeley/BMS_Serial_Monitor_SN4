import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/globals.dart' as globals;
import 'package:serial_monitor/info_table/info_table.dart';
import 'package:serial_monitor/info_table/info_table_entry.dart';

class InfoTableVTStats extends StatefulWidget {
  const InfoTableVTStats({super.key});

  @override
  State<InfoTableVTStats> createState() => _InfoTableVTStatsState();
}

class _InfoTableVTStatsState extends State<InfoTableVTStats> {
  static const double entryWidth = 180;
  static final PackData packData = globals.carData.packData;

  _InfoTableVTStatsState() {
    Timer.periodic(
      Duration(milliseconds: globals.infoTableRefreshRateMs),
      (_) => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InfoTable(
      entries: [
        [
          InfoTableEntry(text: 'Total Voltage', width: entryWidth),
          InfoTableEntry(text: 'Avg. Voltage', width: entryWidth),
          InfoTableEntry(text: 'Avg. Temperature', width: entryWidth),
        ],
        [
          InfoTableEntry(text: packData.stringOfTotalVoltage),
          InfoTableEntry(text: packData.stringOfAverageVoltage),
          InfoTableEntry(text: packData.stringOfAverageTemperature),
        ],
      ],
    );
  }
}
