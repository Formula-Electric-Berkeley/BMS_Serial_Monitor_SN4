import 'package:flutter/material.dart';
import 'package:serial_monitor/globals.dart' as globals;

class InfoTableSettings extends StatefulWidget {
  const InfoTableSettings({super.key});

  @override
  State<InfoTableSettings> createState() => _InfoTableSettingsState();
}

class _InfoTableSettingsState extends State<InfoTableSettings> {
  bool useRedundantVoltage = globals.useRedundantVoltage;
  bool highlightCellLocation = globals.highlightCellLocation;
  bool highlightInvalidVoltage = globals.highlightInvalidVoltage;
  bool highlightInvalidTemperature = globals.highlightInvalidTemperature;
  bool highlightBalancingCells = globals.highlightBalancingCells;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 245, 245, 245),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _SettingsCheckbox(
                    isChecked: useRedundantVoltage,
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() => useRedundantVoltage = value);
                      }
                    },
                  ),
                  Text('Display redundant voltage'),
                ],
              ),
              Row(
                children: [
                  _SettingsCheckbox(
                    isChecked: highlightCellLocation,
                    onChanged: (bool? value) {
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
              Row(
                children: [
                  _SettingsCheckbox(
                    isChecked: highlightBalancingCells,
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() => highlightBalancingCells = value);
                      }
                    },
                  ),
                  Text('Highlight balancing cells'),
                ],
              ),
            ],
          ),

          // Configure
          TextButton(
            onPressed: () {
              globals.useRedundantVoltage = useRedundantVoltage;
              globals.highlightCellLocation = highlightCellLocation;
              globals.highlightInvalidVoltage = highlightInvalidVoltage;
              globals.highlightInvalidTemperature = highlightInvalidTemperature;
              globals.highlightBalancingCells = highlightBalancingCells;
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
      ),
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
