import 'package:flutter/material.dart';
import 'package:serial_monitor/info_table/info_table_ivt.dart';
import 'package:serial_monitor/info_table/info_table_relay.dart';
import 'package:serial_monitor/info_table/info_table_vt.dart';
import 'package:serial_monitor/info_table/info_table_vt_stats.dart';
import 'package:serial_monitor/nav_bar.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: Scaffold(
        body: Column(
          children: [
            NavBar(),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InfoTableVT(),
                    InfoTableVTStats(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InfoTableRelay(),
                        SizedBox(width: 60),
                        InfoTableIVT(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
