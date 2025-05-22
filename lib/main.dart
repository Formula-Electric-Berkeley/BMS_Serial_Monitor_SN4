import 'package:flutter/material.dart';
import 'package:serial_monitor/nav_bar.dart';
import 'package:serial_monitor/pages/charging_page.dart';
import 'package:serial_monitor/pages/home_page.dart';
import 'package:serial_monitor/pages/page_selector.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final PageSelector pageSelector = PageSelector();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: Scaffold(
        body: Column(
          children: [
            NavBar(pageSelector: pageSelector),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListenableBuilder(
                  listenable: pageSelector,
                  builder:
                      (_, _) => switch (pageSelector.currPage) {
                        PageOptions.home => HomePage(),
                        PageOptions.charging => ChargingPage(),
                      },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
