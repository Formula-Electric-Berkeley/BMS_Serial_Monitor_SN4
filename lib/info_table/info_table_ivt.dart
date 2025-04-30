import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/constants.dart';
import 'package:serial_monitor/globals.dart' as globals;
import 'package:serial_monitor/info_table/info_table.dart';
import 'package:serial_monitor/info_table/info_table_entry.dart';

/// [InfoTable] for IVT data.
class InfoTableIVT extends StatefulWidget {
  const InfoTableIVT({super.key});

  @override
  State<InfoTableIVT> createState() => _InfoTableIVTState();
}

class _InfoTableIVTState extends State<InfoTableIVT> {
  static const double entryWidth = 90;
  static final IVTData ivtData = globals.carData.ivtData;

  Timer? _updateTimer;

  _InfoTableIVTState() {
    _updateTimer = Timer.periodic(
      Duration(milliseconds: Constants.infoTableRefreshRateMs),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Timer? updateTimer = _updateTimer;
    if (updateTimer != null) {
      updateTimer.cancel();
      _updateTimer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InfoTable(
      entries: [
        [
          InfoTableEntry(
            text: 'I',
            bgColor: InfoTableColors.headerBgColor,
            width: entryWidth,
          ),
          InfoTableEntry(
            text: 'V1',
            bgColor: InfoTableColors.headerBgColor,
            width: entryWidth,
          ),
          InfoTableEntry(
            text: 'V2',
            bgColor: InfoTableColors.headerBgColor,
            width: entryWidth,
          ),
          InfoTableEntry(
            text: 'V3',
            bgColor: InfoTableColors.headerBgColor,
            width: entryWidth,
          ),
        ],
        [
          InfoTableEntry(text: ivtData.stringOfCurrent),
          InfoTableEntry(text: ivtData.stringOfVoltage1),
          InfoTableEntry(text: ivtData.stringOfVoltage2),
          InfoTableEntry(text: ivtData.stringOfVoltage3),
        ],
      ],
    );
  }
}
