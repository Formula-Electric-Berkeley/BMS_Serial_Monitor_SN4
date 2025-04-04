import 'package:flutter/material.dart';
import 'package:serial_monitor/globals.dart' as globals;
import 'package:serial_monitor/settings/settings.dart';

class NavBar extends StatelessWidget {
  static const double _buttonWidth = 150;

  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Settings button
          SizedBox(
            width: NavBar._buttonWidth,
            child: TextButton.icon(
              label: Text('Settings'),
              icon: Icon(Icons.settings),
              onPressed: showSettings(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(),
              ),
            ),
          ),

          // Serial connect button
          SizedBox(width: NavBar._buttonWidth, child: _SerialConnectButton()),

          // Clear data button
          SizedBox(
            width: NavBar._buttonWidth,
            child: TextButton.icon(
              label: Text('Clear Data'),
              icon: Icon(Icons.clear_sharp),
              onPressed: globals.carData.clear,
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(),
              ),
            ),
          ),
        ],
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
    return TextButton.icon(
      label: connected ? Text('Disconnect') : Text('Connect'),
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
