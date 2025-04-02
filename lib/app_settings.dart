import 'package:flutter/material.dart';

enum _Setting { infoTable, serialPort }

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  _Setting currSetting = _Setting.infoTable;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Settings'),
      contentPadding: EdgeInsets.all(100),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              TextButton.icon(
                label: Text('Info Table'),
                icon: Icon(Icons.table_chart_sharp),
                onPressed: () => setState(() => currSetting = _Setting.infoTable),
                style: TextButton.styleFrom(
                  backgroundColor:
                      currSetting == _Setting.infoTable
                          ? Colors.orange
                          : Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(),
                ),
              ),
              TextButton.icon(
                label: Text('Serial Port'),
                icon: Icon(Icons.cable_sharp),
                onPressed: () => setState(() => currSetting = _Setting.serialPort),
                style: TextButton.styleFrom(
                  backgroundColor:
                      currSetting == _Setting.serialPort
                          ? Colors.orange
                          : Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(),
                ),
              ),
            ],
          ),
          InfoTableSettings(),
        ],
      ),
    );
  }
}

class InfoTableSettings extends StatelessWidget {
  const InfoTableSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.purple,
      child: Column(children: [
        Row(
          children: [
            _SettingsCheckbox(),
            Text('Highlight cell location')
          ],
        )
      ]),
    );
  }
}

class _SettingsCheckbox extends StatefulWidget {
  const _SettingsCheckbox({super.key});

  @override
  State<_SettingsCheckbox> createState() => _SettingsCheckboxState();
}

class _SettingsCheckboxState extends State<_SettingsCheckbox> {
  bool isChecked = false;

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
      onChanged: (bool? value) {
        if (value != null) {
          setState(() => isChecked = value);
        }
      },
    );
  }
}

void Function() showSettings(BuildContext context) {
  void f() {
    showDialog(context: context, builder: (context) => AppSettings());
  }

  return f;
}
