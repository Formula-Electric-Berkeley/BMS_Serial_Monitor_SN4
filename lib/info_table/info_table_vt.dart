import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/constants.dart';
import 'package:serial_monitor/globals.dart' as globals;
import 'package:serial_monitor/info_table/info_table.dart';
import 'package:serial_monitor/info_table/info_table_entry.dart';

/// [InfoTable] for cell voltage and temperature.
class InfoTableVT extends StatefulWidget {
  const InfoTableVT({super.key});

  @override
  State<InfoTableVT> createState() => _InfoTableVTState();
}

class _InfoTableVTState extends State<InfoTableVT> {
  final List<Color> bankNoBgColor = List.filled(
    Constants.numBanks * 2,
    InfoTableColors.headerBgColor,
  );
  final List<Color> cellNoBgColor = List.filled(
    Constants.numCellsPerBank,
    InfoTableColors.defaultBgColor,
  );
  Timer? _updateTimer;

  _InfoTableVTState() {
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

  /// Default background color for every bank.
  ///
  /// Used for alternating colors between banks.
  Color defaultBankBgColor(int bank) =>
      bank % 2 == 0
          ? InfoTableColors.bank0BgColor
          : InfoTableColors.bank1BgColor;

  /// Table header widgets.
  List<Widget> header() {
    return [
      InfoTableEntry(text: 'Cell No.', bgColor: InfoTableColors.headerBgColor),
      ...List.generate(Constants.numBanks * 2, (index) {
        int bank = index ~/ 2 + 1;
        String entryTypeChar = index % 2 == 0 ? 'V' : 'T';
        return InfoTableEntry(
          text: 'B$bank$entryTypeChar',
          bgColor: bankNoBgColor[index],
        );
      }),
    ];
  }

  /// Table body widgets.
  List<List<Widget>> body() {
    return List.generate(
      Constants.numCellsPerBank,
      (cell) => [
        InfoTableEntry(text: '${cell + 1}', bgColor: cellNoBgColor[cell]),
        ...List.generate(Constants.numBanks * 2, (colIndex) {
          int bank = colIndex ~/ 2;
          CellData cellData = globals.carData.getCell(bank, cell);
          Color defaultBgColor = defaultBankBgColor(bank);
          _Entry entry =
              colIndex % 2 == 0
                  ? _VoltageEntry(
                    cellData: cellData,
                    defaultBgColor: defaultBgColor,
                  )
                  : _TemperatureEntry(
                    cellData: cellData,
                    defaultBgColor: defaultBgColor,
                  );
          VoidCallback onDoubleTap =
              colIndex % 2 == 0
                  ? toggleDisableVoltage(cellData)
                  : toggleDisableTemperature(cellData);
          return MouseRegion(
            onEnter: bodyEntryOnEnter(cell, colIndex),
            onExit: bodyEntryOnExit(cell, colIndex),
            child: GestureDetector(onDoubleTap: onDoubleTap, child: entry),
          );
        }),
      ],
    );
  }

  /// On mouse entry, set background color of cell number and bank number.
  ///
  /// Returns a function that can be called on mouse entry.
  void Function(PointerEnterEvent) bodyEntryOnEnter(int cell, int colIndex) {
    void f(PointerEnterEvent event) {
      if (globals.highlightCellLocation) {
        setState(() {
          cellNoBgColor[cell] = InfoTableColors.locateBgColor;
          bankNoBgColor[colIndex] = InfoTableColors.locateBgColor;
        });
      } else {
        if (cellNoBgColor[cell] == InfoTableColors.locateBgColor) {
          setState(() {
            cellNoBgColor[cell] = InfoTableColors.defaultBgColor;
          });
        }
        if (bankNoBgColor[colIndex] == InfoTableColors.locateBgColor) {
          setState(() {
            bankNoBgColor[colIndex] = InfoTableColors.headerBgColor;
          });
        }
      }
    }

    return f;
  }

  /// On mouse exit, set background color of cell number and bank number.
  ///
  /// Returns a function that can be called on mouse exit.
  void Function(PointerExitEvent) bodyEntryOnExit(int cell, int colIndex) {
    void f(PointerExitEvent event) {
      if (cellNoBgColor[cell] == InfoTableColors.locateBgColor) {
        setState(() => cellNoBgColor[cell] = InfoTableColors.defaultBgColor);
      }
      if (bankNoBgColor[colIndex] == InfoTableColors.locateBgColor) {
        setState(
          () => bankNoBgColor[colIndex] = InfoTableColors.headerBgColor,
        );
      }
    }

    return f;
  }

  /// Return a function to toggle a cell's disable voltage.
  VoidCallback toggleDisableVoltage(CellData cellData) =>
      () => cellData.disableVoltage = !cellData.disableVoltage;

  /// Return a function to toggle a cell's disable temperature.
  VoidCallback toggleDisableTemperature(CellData cellData) =>
      () => cellData.disableTemperature = !cellData.disableTemperature;

  /// Bank statistics (total) widgets.
  ///
  /// Widgets for total voltage in a bank.
  List<Widget> statsTotal() {
    return [
      InfoTableEntry(text: 'Total'),
      ...List.generate(Constants.numBanks * 2, (colIndex) {
        int bank = colIndex ~/ 2;
        BankData bankData = globals.carData.getBank(bank);
        Color bgColor = defaultBankBgColor(bank);
        if (colIndex % 2 == 0) {
          return _BankStatEntry(
            bankData: bankData,
            bankStatType: _BankStatType.totalVoltage,
            bgColor: bgColor,
          );
        } else {
          return InfoTableEntry(text: '-', bgColor: bgColor);
        }
      }),
    ];
  }

  /// Bank statistics (average) widgets.
  ///
  /// Widgets for average cell voltage and average
  /// cell temperature in a bank.
  List<Widget> statsAverage() {
    return [
      InfoTableEntry(text: 'Avg.'),
      ...List.generate(Constants.numBanks * 2, (colIndex) {
        int bank = colIndex ~/ 2;
        BankData bankData = globals.carData.getBank(bank);
        Color bgColor = defaultBankBgColor(bank);
        _BankStatType bankStatType =
            colIndex % 2 == 0
                ? _BankStatType.averageVoltage
                : _BankStatType.averageTemperature;
        return _BankStatEntry(
          bankData: bankData,
          bankStatType: bankStatType,
          bgColor: bgColor,
        );
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return InfoTable(
      entries: [header(), ...body(), statsTotal(), statsAverage()],
    );
  }
}

/// Abstract layout for VT table entries.
abstract class _Entry extends StatelessWidget {
  String get text => '';
  Color get bgColor => InfoTableColors.defaultBgColor;
  Color get textColor => InfoTableColors.defaultTextColor;

  @override
  Widget build(BuildContext context) {
    return InfoTableEntry(text: text, bgColor: bgColor, textColor: textColor);
  }
}

/// Table entry for cell voltage.
class _VoltageEntry extends _Entry {
  final Color defaultBgColor;
  final CellData cellData;

  _VoltageEntry({required this.cellData, required this.defaultBgColor});

  @override
  String get text => cellData.stringOfVoltage;

  @override
  Color get bgColor {
    if (cellData.disableVoltage) {
      return defaultBgColor;
    }

    Color bgColor = defaultBgColor;
    if (globals.highlightInvalidVoltage &&
        cellData.isVoltageSet &&
        (cellData.isUnderVoltage || cellData.isOverVoltage)) {
      bgColor = InfoTableColors.outOfRangeBgColor;
    } else if (globals.highlightBalancingCells &&
        cellData.isBalancingSet &&
        cellData.isBalancing) {
      bgColor = InfoTableColors.balanceBgColor;
    }

    return bgColor;
  }

  @override
  Color get textColor =>
      cellData.isVoltageSet && !cellData.disableVoltage
          ? InfoTableColors.defaultTextColor
          : InfoTableColors.disabledTextColor;
}

/// Table entry for cell temperature.
class _TemperatureEntry extends _Entry {
  final Color defaultBgColor;
  final CellData cellData;

  _TemperatureEntry({required this.cellData, required this.defaultBgColor});

  @override
  String get text => cellData.stringOfTemperature;

  @override
  Color get bgColor {
    if (cellData.disableTemperature) {
      return defaultBgColor;
    }

    Color bgColor = defaultBgColor;
    if (globals.highlightInvalidTemperature &&
        cellData.isTemperatureSet &&
        (cellData.isUnderTemperature || cellData.isOverTemperature)) {
      bgColor = InfoTableColors.outOfRangeBgColor;
    }

    return bgColor;
  }

  @override
  Color get textColor =>
      cellData.isTemperatureSet && !cellData.disableTemperature
          ? InfoTableColors.defaultTextColor
          : InfoTableColors.disabledTextColor;
}

enum _BankStatType { totalVoltage, averageVoltage, averageTemperature }

/// Table entry for bank statistics.
class _BankStatEntry extends _Entry {
  final BankData bankData;
  final _BankStatType bankStatType;
  final Color _bgColor;

  _BankStatEntry({
    required this.bankData,
    required this.bankStatType,
    required bgColor,
  }) : _bgColor = bgColor;

  @override
  String get text => switch (bankStatType) {
    _BankStatType.totalVoltage => bankData.stringOfTotalVoltage,
    _BankStatType.averageVoltage => bankData.stringOfAverageVoltage,
    _BankStatType.averageTemperature => bankData.stringOfAverageTemperature,
  };

  @override
  Color get bgColor => _bgColor;
}
