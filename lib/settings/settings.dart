import 'package:flutter/material.dart';
import 'package:serial_monitor/settings/info_table.dart';
import 'package:serial_monitor/settings/serial_port.dart';

enum _SettingPage { infoTable, serialPort }

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  _SettingPage currSettingPage = _SettingPage.serialPort;

  void Function() updateSettingPageCallback(_SettingPage settingPage) {
    return () => setState(() => currSettingPage = settingPage);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(),
      contentPadding: EdgeInsets.all(20),
      content: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            SizedBox(
              width: 150,
              child: _AppSettingsNavigator(
                currSettingPage,
                updateSettingPageCallback,
              ),
            ),
            SizedBox(
              width: 500,
              child: Padding(
                padding: const EdgeInsets.only(),
                child: switch (currSettingPage) {
                  _SettingPage.serialPort => SerialPortSettings(),
                  _SettingPage.infoTable => InfoTableSettings(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppSettingsNavigator extends StatelessWidget {
  final _SettingPage currSettingPage;
  final void Function() Function(_SettingPage) updateSettingPageCallback;

  const _AppSettingsNavigator(
    this.currSettingPage,
    this.updateSettingPageCallback,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 300),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Serial port
          _AppSettingsNavigatorButton(
            text: 'Serial Port',
            backgroundColor:
                currSettingPage == _SettingPage.serialPort
                    ? Colors.orange
                    : Colors.white,
            onPressed: updateSettingPageCallback(_SettingPage.serialPort),
          ),

          // Info table
          _AppSettingsNavigatorButton(
            text: 'Info Table',
            backgroundColor:
                currSettingPage == _SettingPage.infoTable
                    ? Colors.orange
                    : Colors.white,
            onPressed: updateSettingPageCallback(_SettingPage.infoTable),
          ),
        ],
      ),
    );
  }
}

class _AppSettingsNavigatorButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final void Function() onPressed;

  const _AppSettingsNavigatorButton({
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(),
        ),
        child: Text(text),
      ),
    );
  }
}

void Function() showSettings(BuildContext context) {
  void f() {
    showDialog(context: context, builder: (context) => AppSettings());
  }

  return f;
}
