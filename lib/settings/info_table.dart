import 'package:flutter/material.dart';
import 'package:serial_monitor/globals.dart' as globals;

class InfoTableSettings extends StatefulWidget {
  const InfoTableSettings({super.key});

  @override
  State<InfoTableSettings> createState() => _InfoTableSettingsState();
}

class _InfoTableSettingsState extends State<InfoTableSettings> {
  bool highlightCellLocation = globals.highlightCellLocation;
  bool highlightInvalidVoltage = globals.highlightInvalidVoltage;
  bool highlightInvalidTemperature = globals.highlightInvalidTemperature;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _SettingsCheckbox(
                  isChecked: highlightCellLocation,
                  onChanged: (bool? value) {
                    print("location!");
                    if (value != null) {
                      setState(() => highlightCellLocation = value);
                    }
                  },
                ),
                Text('Highlight cell location'),
              ],
            ),
            Row(
              children: [
                _SettingsCheckbox(
                  isChecked: highlightInvalidVoltage,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() => highlightInvalidVoltage = value);
                    }
                  },
                ),
                Text('Highlight out of range voltage'),
              ],
            ),
            Row(
              children: [
                _SettingsCheckbox(
                  isChecked: highlightInvalidTemperature,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() => highlightInvalidTemperature = value);
                    }
                  },
                ),
                Text('Highlight out of range temperature'),
              ],
            ),
          ],
        ),

        // Configure
        TextButton(
          onPressed: () {
            globals.highlightCellLocation = highlightCellLocation;
            globals.highlightInvalidVoltage = highlightInvalidVoltage;
            globals.highlightInvalidTemperature = highlightInvalidTemperature;
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(),
          ),
          child: Text('Configure Info Table'),
        ),
      ],
    );
  }
}

class _SettingsCheckbox extends StatelessWidget {
  final bool isChecked;
  final void Function(bool?) onChanged;

  const _SettingsCheckbox({required this.isChecked, required this.onChanged});

  Color getColor(Set<WidgetState> states) {
    return isChecked ? Colors.orange : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      checkColor: Colors.black,
      fillColor: WidgetStateProperty.resolveWith(getColor),
      shape: RoundedRectangleBorder(),
      splashRadius: 0,
      onChanged: onChanged,
    );
  }
}
