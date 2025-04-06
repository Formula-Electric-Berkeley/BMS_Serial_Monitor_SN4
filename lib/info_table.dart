import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/constants.dart';
import 'package:serial_monitor/globals.dart' as globals;

enum _CellType { voltage, temperature }

enum _BankType { totalVoltage, averageVoltage, averageTemperature }

class InfoTable extends StatefulWidget {
  const InfoTable({super.key});

  @override
  State<InfoTable> createState() => _InfoTableState();
}

class _InfoTableState extends State<InfoTable> {
  List<Color> cellNoColor = List.filled(
    numCellsPerBank,
    InfoTableCell.defaultColor,
  );
  List<Color> bankNoColor = List.filled(
    numBanks * 2,
    InfoTableCell.defaultColor,
  );

  void Function(PointerEnterEvent) infoDataCellOnEnter(int cell, int colIndex) {
    void f(PointerEnterEvent event) {
      if (globals.highlightCellLocation) {
        setState(() {
          cellNoColor[cell] = InfoTableCell.locateColor;
          bankNoColor[colIndex] = InfoTableCell.locateColor;
        });
      } else {
        if (cellNoColor[cell] == InfoTableCell.locateColor) {
          setState(() {
            cellNoColor[cell] = InfoTableCell.defaultColor;
          });
        }
        if (bankNoColor[colIndex] == InfoTableCell.locateColor) {
          setState(() {
            bankNoColor[colIndex] = InfoTableCell.defaultColor;
          });
        }
      }
    }

    return f;
  }

  void Function(PointerExitEvent) infoDataCellOnExit(int cell, int colIndex) {
    void f(PointerExitEvent event) {
      if (cellNoColor[cell] == InfoTableCell.locateColor) {
        setState(() => cellNoColor[cell] = InfoTableCell.defaultColor);
      }
      if (bankNoColor[colIndex] == InfoTableCell.locateColor) {
        setState(() => bankNoColor[colIndex] = InfoTableCell.defaultColor);
      }
    }

    return f;
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            InfoTableCell(text: 'Cell No.'),
            ...List.generate(numBanks * 2, (index) {
              int bank = (index >> 1) + 1;
              String columnType = index % 2 == 0 ? 'V' : 'T';
              return InfoTableCell(
                text: 'B$bank$columnType',
                color: bankNoColor[index],
              );
            }),
          ],
        ),
        ...List.generate(numCellsPerBank, (cell) {
          return TableRow(
            children: [
              InfoTableCell(text: '${cell + 1}', color: cellNoColor[cell]),
              ...List.generate(numBanks * 2, (colIndex) {
                int bank = colIndex ~/ 2;
                CellData cellData = globals.carData.getCell(bank, cell);
                _CellType cellType =
                    colIndex % 2 == 0
                        ? _CellType.voltage
                        : _CellType.temperature;
                Color defaultColor =
                    bank % 2 == 0
                        ? InfoTableCell.defaultColorBank0
                        : InfoTableCell.defaultColorBank1;
                return MouseRegion(
                  onEnter: infoDataCellOnEnter(cell, colIndex),
                  onExit: infoDataCellOnExit(cell, colIndex),
                  child: _CellData(
                    cellData: cellData,
                    cellType: cellType,
                    defaultColor: defaultColor,
                  ),
                );
              }),
            ],
          );
        }),
        TableRow(
          children: [
            InfoTableCell(text: 'Total'),
            ...List.generate(numBanks * 2, (colIndex) {
              int bank = colIndex ~/ 2;
              Color color =
                  bank % 2 == 0
                      ? InfoTableCell.defaultColorBank0
                      : InfoTableCell.defaultColorBank1;
              if (colIndex % 2 == 1) {
                return InfoTableCell(
                  text: '-',
                  color: color,
                  textColor: InfoTableCell.disabledTextColor,
                );
              } else {
                return _InfoBankData(
                  bankData: globals.carData.getBank(bank),
                  bankType: _BankType.totalVoltage,
                  color: color,
                );
              }
            }),
          ],
        ),
        TableRow(
          children: [
            InfoTableCell(text: 'Avg.'),
            ...List.generate(numBanks * 2, (colIndex) {
              int bank = colIndex ~/ 2;
              Color color =
                  bank % 2 == 0
                      ? InfoTableCell.defaultColorBank0
                      : InfoTableCell.defaultColorBank1;
              _BankType bankType =
                  colIndex % 2 == 0
                      ? _BankType.averageVoltage
                      : _BankType.averageTemperature;
              return _InfoBankData(
                bankData: globals.carData.getBank(bank),
                bankType: bankType,
                color: color,
              );
            }),
          ],
        ),
      ],

      border: TableBorder.all(),
      defaultColumnWidth: IntrinsicColumnWidth(),
    );
  }
}

class InfoTableCell extends StatelessWidget {
  static const defaultColor = Colors.white;
  static const defaultColorBank0 = Color.fromARGB(255, 225, 225, 225);
  static const defaultColorBank1 = Colors.white;
  static const outOfRangeColor = Colors.red;
  static const locateColor = Colors.orange;

  static const defaultTextColor = Colors.black;
  static const disabledTextColor = Colors.grey;

  final String _text;
  final Color _color;
  final Color _textColor;

  const InfoTableCell({super.key, String? text, Color? color, Color? textColor})
    : _text = text ?? '',
      _color = color ?? InfoTableCell.defaultColor,
      _textColor = textColor ?? InfoTableCell.defaultTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      color: _color,
      child: Center(child: Text(_text, style: TextStyle(color: _textColor))),
    );
  }
}

class _CellData extends StatefulWidget {
  final CellData cellData;
  final _CellType cellType;
  final Color defaultColor;

  const _CellData({
    required this.cellData,
    required this.cellType,
    required this.defaultColor,
  });

  @override
  State<_CellData> createState() => _CellDataState();

  String get text {
    return cellType == _CellType.voltage
        ? cellData.stringOfVoltage
        : cellData.stringOfTemperature;
  }

  Color get color {
    if (cellType == _CellType.voltage) {
      if (!cellData.isVoltageSet ||
          (!cellData.isUnderVoltage && !cellData.isOverVoltage)) {
        return defaultColor;
      } else {
        return InfoTableCell.outOfRangeColor;
      }
    } else {
      return defaultColor;
    }
  }

  Color get textColor {
    if (cellType == _CellType.voltage) {
      return cellData.isVoltageSet
          ? InfoTableCell.defaultTextColor
          : InfoTableCell.disabledTextColor;
    } else {
      return cellData.isTemperatureSet
          ? InfoTableCell.defaultTextColor
          : InfoTableCell.disabledTextColor;
    }
  }
}

class _CellDataState extends State<_CellData> {
  String text = '';
  Color color = InfoTableCell.defaultColor;
  Color textColor = InfoTableCell.defaultTextColor;

  _CellDataState() {
    Timer.periodic(Duration(milliseconds: 50), updateCell);
  }

  @override
  Widget build(BuildContext context) {
    return InfoTableCell(text: text, color: color, textColor: textColor);
  }

  void updateCell(Timer t) {
    setState(() {
      text = widget.text;
      color = widget.color;
      textColor = widget.textColor;
    });
  }
}

class _InfoBankData extends StatefulWidget {
  final BankData bankData;
  final _BankType bankType;
  final Color color;

  const _InfoBankData({
    required this.bankData,
    required this.bankType,
    required this.color,
  });

  String get text {
    return switch (bankType) {
      _BankType.totalVoltage => bankData.stringOfTotalVoltage,
      _BankType.averageVoltage => bankData.stringOfAverageVoltage,
      _BankType.averageTemperature => bankData.stringOfAverageTemperature,
    };
  }

  @override
  State<_InfoBankData> createState() => _InfoBankDataState();
}

class _InfoBankDataState extends State<_InfoBankData> {
  String text = '';

  _InfoBankDataState() {
    Timer.periodic(Duration(milliseconds: 50), update);
  }

  void update(Timer t) {
    setState(() => text = widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return InfoTableCell(text: text, color: widget.color);
  }
}
