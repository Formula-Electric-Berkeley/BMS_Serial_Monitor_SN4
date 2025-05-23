import 'package:flutter/material.dart';
import 'package:serial_monitor/globals.dart' as globals;
import 'package:serial_monitor/nav_bar.dart';
import 'package:serial_monitor/pages/charging_page.dart';
import 'package:serial_monitor/pages/home_page.dart';
import 'package:serial_monitor/pages/page_selector.dart';

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
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: ListenableBuilder(
                    listenable: globals.pageSelector,
                    builder:
                        (_, _) => switch (globals.pageSelector.currPage) {
                          PageOptions.home => HomePage(),
                          PageOptions.charging => ChargingPage(),
                        },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
