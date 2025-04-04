import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/constants.dart';
import 'package:serial_monitor/globals.dart' as globals;

enum CellType { voltage, temperature }

class InfoTable extends StatefulWidget {
  const InfoTable({super.key});

  @override
  State<InfoTable> createState() => _InfoTableState();
}

class _InfoTableState extends State<InfoTable> {
  List<Color> cellNoColor = List.filled(numCellsPerBank, InfoCell.defaultColor);
  List<Color> bankNoColor = List.filled(numBanks * 2, InfoCell.defaultColor);

  void Function(PointerEnterEvent) infoDataCellOnEnter(int cell, int colIndex) {
    void f(PointerEnterEvent event) {
      if (globals.highlightCellLocation) {
        setState(() {
          cellNoColor[cell] = InfoCell.locateColor;
          bankNoColor[colIndex] = InfoCell.locateColor;
        });
      } else {
        if (cellNoColor[cell] == InfoCell.locateColor) {
          setState(() {
            cellNoColor[cell] = InfoCell.defaultColor;
          });
        }
        if (bankNoColor[colIndex] == InfoCell.locateColor) {
          setState(() {
            bankNoColor[colIndex] = InfoCell.defaultColor;
          });
        }
      }
    }

    return f;
  }

  void Function(PointerExitEvent) infoDataCellOnExit(int cell, int colIndex) {
    void f(PointerExitEvent event) {
      if (cellNoColor[cell] == InfoCell.locateColor) {
        setState(() => cellNoColor[cell] = InfoCell.defaultColor);
      }
      if (bankNoColor[colIndex] == InfoCell.locateColor) {
        setState(() => bankNoColor[colIndex] = InfoCell.defaultColor);
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
            InfoCell(text: 'Cell No.'),
            ...List.generate(numBanks * 2, (index) {
              int bank = (index >> 1) + 1;
              String columnType = index % 2 == 0 ? 'V' : 'T';
              return InfoCell(
                text: 'B$bank$columnType',
                color: bankNoColor[index],
              );
            }),
          ],
        ),
        ...List.generate(numCellsPerBank, (cell) {
          return TableRow(
            children: [
              InfoCell(text: '${cell + 1}', color: cellNoColor[cell]),
              ...List.generate(numBanks * 2, (colIndex) {
                int bank = colIndex ~/ 2;
                CellData cellData = globals.carData.getCell(bank, cell);
                CellType cellType =
                    colIndex % 2 == 0 ? CellType.voltage : CellType.temperature;
                Color defaultColor =
                    bank % 2 == 0
                        ? InfoCell.defaultColorBank0
                        : InfoCell.defaultColorBank1;
                return MouseRegion(
                  onEnter: infoDataCellOnEnter(cell, colIndex),
                  onExit: infoDataCellOnExit(cell, colIndex),
                  child: _InfoCellData(
                    cellData: cellData,
                    cellType: cellType,
                    defaultColor: defaultColor,
                  ),
                );
              }),
            ],
          );
        }),
      ],
      border: TableBorder.all(),
      defaultColumnWidth: IntrinsicColumnWidth(),
    );
  }
}

class InfoCell extends StatelessWidget {
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

  const InfoCell({super.key, String? text, Color? color, Color? textColor})
    : _text = text ?? '',
      _color = color ?? InfoCell.defaultColor,
      _textColor = textColor ?? InfoCell.defaultTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      color: _color,
      child: Center(child: Text(_text, style: TextStyle(color: _textColor))),
    );
  }
}

class _InfoCellData extends StatefulWidget {
  final CellData cellData;
  final CellType cellType;
  final Color defaultColor;

  const _InfoCellData({
    required this.cellData,
    required this.cellType,
    required this.defaultColor,
  });

  @override
  State<_InfoCellData> createState() => _InfoCellDataState();

  String get text {
    return cellType == CellType.voltage
        ? cellData.stringOfVoltage
        : cellData.stringOfTemperature;
  }

  Color get color {
    if (cellType == CellType.voltage) {
      if (!cellData.isVoltageSet ||
          (!cellData.isUnderVoltage && !cellData.isOverVoltage)) {
        return defaultColor;
      } else {
        return InfoCell.outOfRangeColor;
      }
    } else {
      return defaultColor;
    }
  }

  Color get textColor {
    if (cellType == CellType.voltage) {
      return cellData.isVoltageSet
          ? InfoCell.defaultTextColor
          : InfoCell.disabledTextColor;
    } else {
      return cellData.isTemperatureSet
          ? InfoCell.defaultTextColor
          : InfoCell.disabledTextColor;
    }
  }
}

class _InfoCellDataState extends State<_InfoCellData> {
  String text = '';
  Color color = InfoCell.defaultColor;
  Color textColor = InfoCell.defaultTextColor;

  _InfoCellDataState() {
    Timer.periodic(Duration(milliseconds: 50), updateCell);
  }

  @override
  Widget build(BuildContext context) {
    return InfoCell(text: text, color: color, textColor: textColor);
  }

  void updateCell(Timer t) {
    setState(() {
      text = widget.text;
      color = widget.color;
      textColor = widget.textColor;
    });
  }
}
