import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/constants.dart';
import 'package:serial_monitor/globals.dart' as globals;
import 'package:serial_monitor/info_table/info_table.dart';
import 'package:serial_monitor/info_table/info_table_entry.dart';

/// [InfoTable] for relays.
class InfoTableRelay extends StatefulWidget {
  const InfoTableRelay({super.key});

  @override
  State<InfoTableRelay> createState() => _InfoTableRelayState();
}

class _InfoTableRelayState extends State<InfoTableRelay> {
  static const double entryWidth = 90;
  static final RelayData relayData = globals.carData.relayData;

  _InfoTableRelayState() {
    Timer.periodic(
      Duration(milliseconds: Constants.infoTableRefreshRateMs),
      (_) => setState(() {}),
    );
  }

  Color bgColor(bool? isOpen) => switch (isOpen) {
    true => InfoTableColors.relayOpenBgColor,
    false => InfoTableColors.relayClosedBgColor,
    _ => InfoTableColors.defaultBgColor,
  };

  @override
  Widget build(BuildContext context) {
    return InfoTable(
      entries: [
        [
          InfoTableEntry(text: 'AIR+', width: entryWidth),
          InfoTableEntry(text: 'AIR-', width: entryWidth),
          InfoTableEntry(text: 'Precharge', width: entryWidth),
        ],
        [
          InfoTableEntry(
            text: relayData.stringOfAirPlus,
            bgColor: bgColor(relayData.airPlusOpen),
          ),
          InfoTableEntry(
            text: relayData.stringOfAirMinus,
            bgColor: bgColor(relayData.airMinusOpen),
          ),
          InfoTableEntry(
            text: relayData.stringOfPrecharge,
            bgColor: bgColor(relayData.prechargeOpen),
          ),
        ],
      ],
    );
  }
}
