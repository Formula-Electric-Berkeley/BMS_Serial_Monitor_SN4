import 'package:flutter/material.dart';
import 'package:serial_monitor/info_table/info_table_ivt.dart';
import 'package:serial_monitor/info_table/info_table_relay.dart';
import 'package:serial_monitor/info_table/info_table_vt.dart';
import 'package:serial_monitor/info_table/info_table_vt_stats.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        InfoTableVT(),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InfoTableVTStats(),
            SizedBox(width: 90),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoTableRelay(),
                SizedBox(height: 30),
                InfoTableIVT(),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
