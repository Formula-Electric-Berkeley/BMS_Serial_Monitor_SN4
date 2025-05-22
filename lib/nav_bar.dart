import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/globals.dart' as globals;
import 'package:serial_monitor/pages/page_selector.dart';
import 'package:serial_monitor/settings/settings.dart';

class NavBar extends StatelessWidget {
  final PageSelector pageSelector;

  const NavBar({super.key, required this.pageSelector});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Column(
        children: [
          Row(
            children: [
              _PageSelectorButton(
                text: 'Home',
                pageSelector: pageSelector,
                pageOption: PageOptions.home,
              ),
              _PageSelectorButton(
                text: 'Charging',
                pageSelector: pageSelector,
                pageOption: PageOptions.charging,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Tooltip(message: 'Settings', child: _SettingsButton()),
              Tooltip(message: 'Serial Connect', child: _SerialConnectButton()),
              Tooltip(message: 'Enable All VT', child: _EnableVTButton()),
              Tooltip(message: 'Debug Mode', child: _DebugModeButton()),
              Tooltip(message: 'Clear Data', child: _ClearDataButton()),
            ],
          ),
        ],
      ),
    );
  }
}

class _PageSelectorButton extends StatelessWidget {
  final String text;
  final PageSelector pageSelector;
  final PageOptions pageOption;

  const _PageSelectorButton({
    required this.text,
    required this.pageSelector,
    required this.pageOption,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 150,
      child: ListenableBuilder(
        listenable: pageSelector,
        builder:
            (_, _) => TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    pageSelector.currPage == pageOption
                        ? Colors.deepOrange
                        : null,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(),
              ),
              onPressed: () => pageSelector.currPage = pageOption,
              child: Text(text),
            ),
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
        backgroundColor: connected ? Colors.deepOrange : null,
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
  void dispose() {
    super.dispose();
    Timer? t = timer;
    if (t != null) {
      t.cancel();
      timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.bug_report_outlined),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: timer != null ? Colors.deepOrange : null,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(),
      ),
    );
  }
}
