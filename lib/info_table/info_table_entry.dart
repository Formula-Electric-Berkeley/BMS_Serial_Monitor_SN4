import 'package:flutter/material.dart';
import 'package:serial_monitor/info_table/info_table.dart';

/// [Color] constants used for [InfoTableEntry].
abstract final class InfoTableColors {
  // Background colors
  static const Color defaultBgColor = Colors.white;
  static const Color headerBgColor = Colors.orangeAccent;
  static const Color bank0BgColor = Color.fromARGB(255, 225, 225, 225);
  static const Color bank1BgColor = Colors.white;
  static const Color outOfRangeBgColor = Colors.deepOrange;
  static const Color locateBgColor = Colors.deepOrange;
  static const Color balanceBgColor = Colors.blue;
  static const Color relayOpenBgColor = Colors.lightGreen;
  static const Color relayClosedBgColor = Colors.deepOrange;
  static const Color chargingNormalBgColor = Colors.lightGreen;
  static const Color chargingFaultBgColor = Colors.deepOrange;

  // Text colors
  static const Color defaultTextColor = Colors.black;
  static const Color disabledTextColor = Colors.grey;
}

/// A single entry in an [InfoTable].
class InfoTableEntry extends StatelessWidget {
  final String _text;
  final Color _bgColor;
  final Color _textColor;
  final double _width;

  const InfoTableEntry({
    super.key,
    String? text,
    Color? bgColor,
    Color? textColor,
    double? width,
  }) : _text = text ?? '',
       _bgColor = bgColor ?? InfoTableColors.defaultBgColor,
       _textColor = textColor ?? InfoTableColors.defaultTextColor,
       _width = width ?? 60;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      color: _bgColor,
      child: Center(child: Text(_text, style: TextStyle(color: _textColor))),
    );
  }
}
