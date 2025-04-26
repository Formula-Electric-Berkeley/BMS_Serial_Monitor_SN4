import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/globals.dart' as globals;
import 'package:serial_monitor/settings/settings.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Tooltip(message: 'Settings', child: _SettingsButton()),
          Tooltip(message: 'Serial Connect', child: _SerialConnectButton()),
          Tooltip(message: 'Enable All VT', child: _EnableVTButton()),
          Tooltip(message: 'Debug', child: _DebugModeButton()),
          Tooltip(message: 'Clear Data', child: _ClearDataButton()),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: showSettings(context),
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(),
      ),
    );
  }
}

class _ClearDataButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.clear_sharp),
      onPressed: globals.carData.clear,
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(),
      ),
    );
  }
}

class _EnableVTButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.show_chart),
      onPressed: globals.carData.enable,
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(),
      ),
    );
  }
}

class _SerialConnectButton extends StatefulWidget {
  const _SerialConnectButton();

  @override
  State<_SerialConnectButton> createState() => _SerialConnectButtonState();
}

class _SerialConnectButtonState extends State<_SerialConnectButton> {
  bool connected = globals.serialMonitor.connected;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.compare_arrows),
      onPressed: () {
        if (globals.serialMonitor.connected) {
          globals.serialMonitor.close();
        } else {
          globals.serialMonitor.open();
        }
        if (connected != globals.serialMonitor.connected) {
          setState(() => connected = globals.serialMonitor.connected);
        }
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(),
      ),
    );
  }
}

class _DebugModeButton extends StatefulWidget {
  const _DebugModeButton();

  @override
  State<_DebugModeButton> createState() => _DebugModeButtonState();
}

class _DebugModeButtonState extends State<_DebugModeButton> {
  final VoidCallback randomizeCallback;
  final Duration timerDuration = const Duration(seconds: 1);
  Timer? timer;

  _DebugModeButtonState() : randomizeCallback = randomizeCarData();

  void onPressed() {
    Timer? t = timer;
    if (t == null) {
      randomizeCallback();
      t = Timer.periodic(timerDuration, (Timer t) => randomizeCallback());
    } else {
      t.cancel();
      t = null;
    }
    setState(() {
      timer = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.bug_report_outlined),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(),
      ),
    );
  }
}
