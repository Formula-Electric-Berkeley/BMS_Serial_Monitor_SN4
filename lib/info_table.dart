import 'dart:async';

import 'package:flutter/material.dart';
import 'constants.dart';
import 'car_data.dart';

enum CellType { voltage, temperature }

class InfoTable extends StatefulWidget {
  final CarData carData;

  const InfoTable(this.carData, {super.key});

  @override
  State<InfoTable> createState() => _InfoTableState();
}

class _InfoTableState extends State<InfoTable> {
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
              return InfoCell(text: 'B$bank$columnType');
            }),
          ],
        ),
        ...List.generate(numCellsPerBank, (cell) {
          return TableRow(
            children: [
              InfoCell(text: '${cell + 1}'),
              ...List.generate(numBanks * 2, (colIndex) {
                int bank = colIndex ~/ 2;
                CellData cellData = widget.carData.getCell(bank, cell);
                CellType cellType =
                    colIndex % 2 == 0 ? CellType.voltage : CellType.temperature;
                Color defaultColor =
                    bank % 2 == 0
                        ? InfoCell.defaultColorBank0
                        : InfoCell.defaultColorBank1;
                return InfoCellData(
                  cellData: cellData,
                  cellType: cellType,
                  defaultColor: defaultColor,
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

  final String _text;
  final Color _color;

  const InfoCell({super.key, String? text, Color? color})
    : _text = text ?? '',
      _color = color ?? InfoCell.defaultColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      color: _color,
      child: Center(child: Text(_text)),
    );
  }
}

class InfoCellData extends StatefulWidget {
  final CellData cellData;
  final CellType cellType;
  final Color defaultColor;

  const InfoCellData({
    super.key,
    required this.cellData,
    required this.cellType,
    required this.defaultColor,
  });

  @override
  State<InfoCellData> createState() => _InfoCellDataState();

  String get text {
    return cellType == CellType.voltage
        ? cellData.stringOfVoltage
        : cellData.stringOfTemperature;
  }

  Color get color {
    if (cellType == CellType.voltage) {
      bool outOfRange = cellData.isUnderVoltage || cellData.isOverVoltage;
      return outOfRange ? InfoCell.outOfRangeColor : defaultColor;
    } else {
      return defaultColor;
    }
  }
}

class _InfoCellDataState extends State<InfoCellData> {
  String text = '';
  Color color = InfoCell.defaultColor;

  _InfoCellDataState() {
    Timer.periodic(Duration(milliseconds: 1000), updateCell);
  }

  @override
  Widget build(BuildContext context) {
    return InfoCell(text: text, color: color);
  }

  void updateCell(Timer t) {
    setState(() {
      text = widget.text;
      color = widget.color;
    });
  }
}
