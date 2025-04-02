import 'dart:async';
import 'dart:math';

import 'package:serial_monitor/constants.dart';

class CarData {
  final List<CellData> _cells = List.generate(
    numBanks * numCellsPerBank,
    (index) => CellData(),
  );

  CellData getCell(int bank, int cell) {
    return _cells[bank * numCellsPerBank + cell];
  }

  void clear() {
    for (CellData cellData in _cells) {
      cellData.clear();
    }
  }
}

class CellData {
  static const _defaultVoltage = 0;
  static const _defaultTemperature = 0;

  double? voltage;
  double? temperature;

  CellData({this.voltage, this.temperature});

  String get stringOfVoltage {
    return (voltage ?? _defaultVoltage).toStringAsFixed(
      voltageDecimalPrecision,
    );
  }

  String get stringOfTemperature {
    return (temperature ?? _defaultTemperature).toStringAsFixed(
      temperatureDecimalPrecision,
    );
  }

  bool get isUnderVoltage {
    return (voltage ?? _defaultVoltage) < minCellVoltage;
  }

  bool get isOverVoltage {
    return (voltage ?? _defaultVoltage) > maxCellVoltage;
  }

  bool get isVoltageSet {
    return voltage != null;
  }

  bool get isTemperatureSet {
    return temperature != null;
  }

  void clear() {
    voltage = null;
    temperature = null;
  }
}

/// Return a function that randomizes car data.
///
/// Used to test GUI by generating random data.
/// Returned function can be called periodically to simulate a stream
/// of data from the car.
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
