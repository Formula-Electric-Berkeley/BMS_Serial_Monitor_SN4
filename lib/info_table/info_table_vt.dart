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
    InfoTableColors.defaultBgColor,
  );
  final List<Color> cellNoBgColor = List.filled(
    Constants.numCellsPerBank,
    InfoTableColors.defaultBgColor,
  );

  _InfoTableVTState() {
    Timer.periodic(
      Duration(milliseconds: Constants.infoTableRefreshRateMs),
      (_) => setState(() {}),
    );
  }

  Color defaultBankBgColor(int bank) =>
      bank % 2 == 0
          ? InfoTableColors.bank0BgColor
          : InfoTableColors.bank1BgColor;

  List<Widget> header() {
    return [
      InfoTableEntry(text: 'Cell No.'),
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
          return MouseRegion(
            onEnter: bodyEntryOnEnter(cell, colIndex),
            onExit: bodyEntryOnExit(cell, colIndex),
            child: entry,
          );
        }),
      ],
    );
  }

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
            bankNoBgColor[colIndex] = InfoTableColors.defaultBgColor;
          });
        }
      }
    }

    return f;
  }

  void Function(PointerExitEvent) bodyEntryOnExit(int cell, int colIndex) {
    void f(PointerExitEvent event) {
      if (cellNoBgColor[cell] == InfoTableColors.locateBgColor) {
        setState(() => cellNoBgColor[cell] = InfoTableColors.defaultBgColor);
      }
      if (bankNoBgColor[colIndex] == InfoTableColors.locateBgColor) {
        setState(
          () => bankNoBgColor[colIndex] = InfoTableColors.defaultBgColor,
        );
      }
    }

    return f;
  }

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

abstract class _Entry extends StatelessWidget {
  String get text => '';
  Color get bgColor => InfoTableColors.defaultBgColor;
  Color get textColor => InfoTableColors.defaultTextColor;

  @override
  Widget build(BuildContext context) {
    return InfoTableEntry(text: text, bgColor: bgColor, textColor: textColor);
  }
}

class _VoltageEntry extends _Entry {
  final Color defaultBgColor;
  final CellData cellData;

  _VoltageEntry({required this.cellData, required this.defaultBgColor});

  @override
  String get text => cellData.stringOfVoltage;

  @override
  Color get bgColor {
    if (globals.highlightInvalidVoltage &&
        cellData.isVoltageSet &&
        (cellData.isUnderVoltage || cellData.isOverVoltage)) {
      return InfoTableColors.outOfRangeBgColor;
    } else if (globals.highlightBalancingCells &&
        cellData.isBalancingSet &&
        cellData.isBalancingOrDefault) {
      return InfoTableColors.balanceBgColor;
    } else {
      return defaultBgColor;
    }
  }

  @override
  Color get textColor =>
      cellData.isVoltageSet
          ? InfoTableColors.defaultTextColor
          : InfoTableColors.disabledTextColor;
}

class _TemperatureEntry extends _Entry {
  final Color defaultBgColor;
  final CellData cellData;

  _TemperatureEntry({required this.cellData, required this.defaultBgColor});

  @override
  String get text => cellData.stringOfTemperature;

  @override
  Color get bgColor {
    // TODO: Implement
    return defaultBgColor;
  }

  @override
  Color get textColor =>
      cellData.isTemperatureSet
          ? InfoTableColors.defaultTextColor
          : InfoTableColors.disabledTextColor;
}

enum _BankStatType { totalVoltage, averageVoltage, averageTemperature }

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
