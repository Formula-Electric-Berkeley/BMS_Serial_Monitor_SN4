import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/constants.dart';
import 'package:serial_monitor/globals.dart' as globals;
import 'package:serial_monitor/info_table/info_table.dart';
import 'package:serial_monitor/info_table/info_table_entry.dart';

class InfoTableChargingRequest extends StatefulWidget {
  const InfoTableChargingRequest({super.key});

  @override
  State<InfoTableChargingRequest> createState() =>
      _InfoTableChargingRequestState();
}

class _InfoTableChargingRequestState extends State<InfoTableChargingRequest> {
  static const double entryWidth = 120;
  static final ChargingData chargingData = globals.carData.chargingData;

  Timer? _updateTimer;

  _InfoTableChargingRequestState() {
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
            text: 'Max Voltage',
            bgColor: InfoTableColors.headerBgColor,
            width: entryWidth,
          ),
          InfoTableEntry(
            text: 'Max Current',
            bgColor: InfoTableColors.headerBgColor,
            width: entryWidth,
          ),
          InfoTableEntry(
            text: 'Control',
            bgColor: InfoTableColors.headerBgColor,
            width: entryWidth,
          ),
        ],
        [
          InfoTableEntry(text: chargingData.maxVoltage),
          InfoTableEntry(text: chargingData.maxCurrent),
          InfoTableEntry(
            text: chargingData.controlDescription,
            bgColor: switch (chargingData.controlFlag) {
              false => InfoTableColors.chargingNormalBgColor,
              true => InfoTableColors.chargingFaultBgColor,
              _ => null,
            },
          ),
        ],
      ],
    );
  }
}

class InfoTableChargingOutput extends StatefulWidget {
  const InfoTableChargingOutput({super.key});

  @override
  State<InfoTableChargingOutput> createState() =>
      _InfoTableChargingOutputState();
}

class _InfoTableChargingOutputState extends State<InfoTableChargingOutput> {
  static const double entryWidth = 180;
  static final ChargingData chargingData = globals.carData.chargingData;

  Timer? _updateTimer;

  _InfoTableChargingOutputState() {
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
            text: 'Output Voltage',
            bgColor: InfoTableColors.headerBgColor,
            width: entryWidth,
          ),
          InfoTableEntry(
            text: 'Output Current',
            bgColor: InfoTableColors.headerBgColor,
            width: entryWidth,
          ),
        ],
        [
          InfoTableEntry(text: chargingData.outputVoltage),
          InfoTableEntry(text: chargingData.outputCurrent),
        ],
      ],
    );
  }
}

class InfoTableChargingFlags extends StatefulWidget {
  const InfoTableChargingFlags({super.key});

  @override
  State<InfoTableChargingFlags> createState() => _InfoTableChargingFlagsState();
}

class _InfoTableChargingFlagsState extends State<InfoTableChargingFlags> {
  static final ChargingData chargingData = globals.carData.chargingData;

  Timer? _updateTimer;

  _InfoTableChargingFlagsState() {
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
            text: 'Hardware',
            bgColor: InfoTableColors.headerBgColor,
            width: 150,
          ),
          InfoTableEntry(
            text: 'Temperature',
            bgColor: InfoTableColors.headerBgColor,
            width: 240,
          ),
          InfoTableEntry(
            text: 'Input Voltage',
            bgColor: InfoTableColors.headerBgColor,
            width: 120,
          ),
          InfoTableEntry(
            text: 'Charging State',
            bgColor: InfoTableColors.headerBgColor,
            width: 270,
          ),
          InfoTableEntry(
            text: 'Communication State',
            bgColor: InfoTableColors.headerBgColor,
            width: 180,
          ),
        ],
        [
          InfoTableEntry(
            text: chargingData.hardwareDescription,
            bgColor: _flagBgColor(chargingData.hardwareFlag),
          ),
          InfoTableEntry(
            text: chargingData.temperatureDescription,
            bgColor: _flagBgColor(chargingData.temperatureFlag),
          ),
          InfoTableEntry(
            text: chargingData.inputVoltageDescription,
            bgColor: _flagBgColor(chargingData.inputVoltageFlag),
          ),
          InfoTableEntry(
            text: chargingData.chargingStateDescription,
            bgColor: _flagBgColor(chargingData.chargingState),
          ),
          InfoTableEntry(
            text: chargingData.communicationStateDescription,
            bgColor: _flagBgColor(chargingData.communicationState),
          ),
        ],
      ],
    );
  }

  Color? _flagBgColor(bool? value) => switch (value) {
    false => InfoTableColors.chargingNormalBgColor,
    true => InfoTableColors.chargingFaultBgColor,
    _ => null,
  };
}
