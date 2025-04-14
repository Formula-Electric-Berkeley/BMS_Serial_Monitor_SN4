import 'package:flutter/material.dart';
import 'package:serial_monitor/info_table/info_table.dart';
import 'package:serial_monitor/info_table/info_table_entry.dart';

class InfoTableVTStats extends StatefulWidget {
  const InfoTableVTStats({super.key});

  @override
  State<InfoTableVTStats> createState() => _InfoTableVTStatsState();
}

class _InfoTableVTStatsState extends State<InfoTableVTStats> {
  static const double entryWidth = 180;

  @override
  Widget build(BuildContext context) {
    return InfoTable(
      entries: [
        [
          InfoTableEntry(text: 'Total Voltage', width: entryWidth),
          InfoTableEntry(text: 'Avg. Voltage', width: entryWidth),
          InfoTableEntry(text: 'Avg. Temperature', width: entryWidth),
        ],
        [InfoTableEntry(), InfoTableEntry(), InfoTableEntry()],
      ],
    );
  }
}
