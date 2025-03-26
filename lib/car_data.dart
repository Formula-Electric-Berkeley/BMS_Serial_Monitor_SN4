import 'dart:async';
import 'dart:math';

import 'constants.dart';

class CarData {
  final List<CellData> _cells = List.generate(
    numBanks * numCellsPerBank,
    (index) => CellData(),
  );

  CellData getCell(int bank, int cell) {
    return _cells[bank * numCellsPerBank + cell];
  }
}

class CellData {
  double voltage;
  double temperature;

  CellData({this.voltage = 0, this.temperature = 0});

  String get stringOfVoltage {
    return voltage.toStringAsFixed(voltageDecimalPrecision);
  }

  String get stringOfTemperature {
    return temperature.toStringAsFixed(temperatureDecimalPrecision);
  }

  bool get isUnderVoltage {
    return voltage < minCellVoltage;
  }

  bool get isOverVoltage {
    return voltage > maxCellVoltage;
  }
}

// TODO: Remove function
void Function(Timer) randomizeData(CarData carData) {
  void f(Timer t) {
    Random r = Random();
    for (int bank = 0; bank < numBanks; bank++) {
      for (int cell = 0; cell < numCellsPerBank; cell++) {
        carData.getCell(bank, cell).voltage = r.nextDouble() * 1.8 + 2.45;
        carData.getCell(bank, cell).temperature = r.nextDouble() * 60;
      }
    }
  }

  return f;
}
