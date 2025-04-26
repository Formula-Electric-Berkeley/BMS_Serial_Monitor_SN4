import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/constants.dart';
import 'package:serial_monitor/globals.dart' as globals;
import 'package:serial_monitor/info_table/info_table.dart';
import 'package:serial_monitor/info_table/info_table_entry.dart';

class InfoTableVTStats extends StatefulWidget {
  const InfoTableVTStats({super.key});

  @override
  State<InfoTableVTStats> createState() => _InfoTableVTStatsState();
}

class _InfoTableVTStatsState extends State<InfoTableVTStats> {
  static const double entryWidth = 120;
  static final PackData packData = globals.carData.packData;

  _InfoTableVTStatsState() {
    Timer.periodic(
      Duration(milliseconds: Constants.infoTableRefreshRateMs),
      (_) => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InfoTable(
      entries: [
        [
          InfoTableEntry(
            text: 'Statistic',
            bgColor: InfoTableColors.headerBgColor,
            width: entryWidth,
          ),
          InfoTableEntry(
            text: 'Voltage',
            bgColor: InfoTableColors.headerBgColor,
            width: entryWidth,
          ),
          InfoTableEntry(
            text: 'Temperature',
            bgColor: InfoTableColors.headerBgColor,
            width: entryWidth,
          ),
        ],
        [
          InfoTableEntry(text: 'Minimum'),
          InfoTableEntry(text: packData.stringOfMinVoltage),
          InfoTableEntry(text: packData.stringOfMinTemperature),
        ],
        [
          InfoTableEntry(text: 'Maximum'),
          InfoTableEntry(text: packData.stringOfMaxVoltage),
          InfoTableEntry(text: packData.stringOfMaxTemperature),
        ],
        [
          InfoTableEntry(text: 'Average'),
          InfoTableEntry(text: packData.stringOfAverageVoltage),
          InfoTableEntry(text: packData.stringOfAverageTemperature),
        ],
        [
          InfoTableEntry(text: 'Total'),
          InfoTableEntry(text: packData.stringOfTotalVoltage),
          InfoTableEntry(text: '-'),
        ],
      ],
    );
  }
}
