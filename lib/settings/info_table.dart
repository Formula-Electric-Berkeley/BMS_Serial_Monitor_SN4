import 'package:flutter/material.dart';

class InfoTableSettings extends StatelessWidget {
  const InfoTableSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [_SettingsCheckbox(), Text('Highlight cell location')]),
      ],
    );
  }
}

class _SettingsCheckbox extends StatefulWidget {
  const _SettingsCheckbox();

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