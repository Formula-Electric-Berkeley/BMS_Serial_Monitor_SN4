import 'dart:async';
import 'dart:math';

import 'package:serial_monitor/constants.dart';
import 'package:serial_monitor/globals.dart' as globals;

class CarData {
  /// List of cell-related statistics.
  final List<CellData> _cells = List.generate(
    Constants.numBanks * Constants.numCellsPerBank,
    (_) => CellData(),
  );

  /// List of bank-related statistics.
  final List<BankData> _banks = List.generate(
    Constants.numBanks,
    (bank) => BankData(),
  );

  /// Pack-related statistics.
  final PackData packData = PackData();

  /// Collection of relay states.
  final RelayData relayData = RelayData();

  /// IVT voltage and current data.
  final IVTData ivtData = IVTData();

  CarData() {
    Timer.periodic(Duration(milliseconds: 100), _update);
  }

  /// Get cell statistics.
  CellData getCell(int bank, int cell) {
    return _cells[bank * Constants.numCellsPerBank + cell];
  }

  /// Get bank statistics.
  BankData getBank(int bank) {
    return _banks[bank];
  }

  void _update(Timer t) {
    for (int bank = 0; bank < Constants.numBanks; bank++) {
      _updateBank(bank);
    }
    _updatePack();
  }

  /// Update bank statistics.
  void _updateBank(int bank) {
    double totalVoltage = 0;
    double totalTemperature = 0;
    int numVoltageCells = 0;
    int numTemperatureCells = 0;

    for (int cell = 0; cell < Constants.numCellsPerBank; cell++) {
      CellData cellData = getCell(bank, cell);

      // Accumulate cell voltage
      double? cellVoltage = cellData.voltage;
      if (cellVoltage != null) {
        totalVoltage += cellVoltage;
        numVoltageCells++;
      }

      // Accumulate cell temperature
      double? cellTemperature = cellData.temperature;
      if (cellTemperature != null) {
        totalTemperature += cellTemperature;
        numTemperatureCells++;
      }
    }

    // Update bank data
    BankData bankData = _banks[bank];
    bankData.totalVoltage = totalVoltage;
    bankData.totalTemperature = totalTemperature;
    bankData.numVoltageCells = numVoltageCells;
    bankData.numTemperatureCells = numTemperatureCells;
  }

  /// Update pack statistics.
  ///
  /// Computes pack data from bank data.
  /// Recommended to call this function after
  /// calling [_updateBank] for all banks.
  void _updatePack() {
    double totalVoltage = 0;
    double totalTemperature = 0;
    int numVoltageCells = 0;
    int numTemperatureCells = 0;

    for (BankData bankData in _banks) {
      // Accumulate bank voltage
      totalVoltage += bankData.totalVoltage;
      numVoltageCells += bankData.numVoltageCells;

      // Accumulate bank temperature
      totalTemperature += bankData.totalTemperature;
      numTemperatureCells += bankData.numTemperatureCells;
    }

    // Store data
    packData.totalVoltage = totalVoltage;
    packData.totalTemperature = totalTemperature;
    packData.numVoltageCells = numVoltageCells;
    packData.numTemperatureCells = numTemperatureCells;
  }

  /// Reset all statistics.
  void clear() {
    for (CellData cellData in _cells) {
      cellData.clear();
    }
  }
}

/// Cell-related statistics.
class CellData {
  static const _defaultVoltage = 0;
  static const _defaultTemperature = 0;
  static const _defaultIsBalancing = false;

  double? voltage;
  double? temperature;
  bool? isBalancing;

  String get stringOfVoltage {
    return (voltage ?? _defaultVoltage).toStringAsFixed(
      Constants.voltageDecimalPrecision,
    );
  }

  String get stringOfTemperature {
    return (temperature ?? _defaultTemperature).toStringAsFixed(
      Constants.temperatureDecimalPrecision,
    );
  }

  bool get isUnderVoltage {
    return (voltage ?? _defaultVoltage) < Constants.minCellVoltage;
  }

  bool get isOverVoltage {
    return (voltage ?? _defaultVoltage) > Constants.maxCellVoltage;
  }

  bool get isVoltageSet {
    return voltage != null;
  }

  bool get isTemperatureSet {
    return temperature != null;
  }

  bool get isBalancingSet {
    return isBalancing != null;
  }

  bool get isBalancingOrDefault {
    return isBalancing ?? _defaultIsBalancing;
  }

  void clear() {
    voltage = null;
    temperature = null;
  }
}

/// Bank-related statistics.
class BankData {
  double totalVoltage = 0;
  double totalTemperature = 0;
  int numVoltageCells = 0;
  int numTemperatureCells = 0;

  String get stringOfTotalVoltage {
    return totalVoltage.toStringAsFixed(Constants.voltageDecimalPrecision);
  }

  String get stringOfAverageVoltage {
    return (totalVoltage / numVoltageCells).toStringAsFixed(
      Constants.voltageDecimalPrecision,
    );
  }

  String get stringOfAverageTemperature {
    return (totalTemperature / numTemperatureCells).toStringAsFixed(
      Constants.temperatureDecimalPrecision,
    );
  }
}

/// Pack-related statistics.
class PackData {
  double totalVoltage = 0;
  double totalTemperature = 0;
  int numVoltageCells = 0;
  int numTemperatureCells = 0;

  String get stringOfTotalVoltage =>
      totalVoltage.toStringAsFixed(Constants.voltageDecimalPrecision);

  String get stringOfAverageVoltage => (totalVoltage / numVoltageCells)
      .toStringAsFixed(Constants.voltageDecimalPrecision);

  String get stringOfAverageTemperature =>
      (totalTemperature / numTemperatureCells).toStringAsFixed(
        Constants.temperatureDecimalPrecision,
      );
}

/// Relay state.
class RelayData {
  bool? airPlusOpen;
  bool? airMinusOpen;
  bool? prechargeOpen;

  String get stringOfAirPlus => switch (airPlusOpen) {
    true => 'Open',
    false => 'Close',
    _ => '-',
  };

  String get stringOfAirMinus => switch (airMinusOpen) {
    true => 'Open',
    false => 'Close',
    _ => '-',
  };

  String get stringOfPrecharge => switch (prechargeOpen) {
    true => 'Open',
    false => 'Close',
    _ => '-',
  };
}

/// IVT data.
class IVTData {
  double? current;
  double? voltage1;
  double? voltage2;
  double? voltage3;

  String get stringOfCurrent {
    double? current = this.current;
    return current != null
        ? current.toStringAsFixed(Constants.currentDecimalPrecision)
        : '-';
  }

  String get stringOfVoltage1 {
    double? voltage1 = this.voltage1;
    return voltage1 != null
        ? voltage1.toStringAsFixed(Constants.voltageDecimalPrecision)
        : '-';
  }

  String get stringOfVoltage2 {
    double? voltage2 = this.voltage2;
    return voltage2 != null
        ? voltage2.toStringAsFixed(Constants.voltageDecimalPrecision)
        : '-';
  }

  String get stringOfVoltage3 {
    double? voltage3 = this.voltage3;
    return voltage3 != null
        ? voltage3.toStringAsFixed(Constants.voltageDecimalPrecision)
        : '-';
  }
}

/// Randomize global [CarData] struct.
///
/// Used to test GUI by generating random data.
/// Randomization occurs periodically, at a set
/// interval.
void randomizeData() {
  CarData carData = globals.carData;
  Random r = Random();

  void f(Timer t) {
    for (int bank = 0; bank < Constants.numBanks; bank++) {
      for (int cell = 0; cell < Constants.numCellsPerBank; cell++) {
        // Cell data
        CellData cellData = carData.getCell(bank, cell);
        cellData.voltage = r.nextDouble() * 1.8 + 2.45;
        cellData.temperature = r.nextDouble() * 60;
        cellData.isBalancing = r.nextDouble() > 0.9;

        // Relay data
        RelayData relayData = carData.relayData;
        relayData.airPlusOpen = r.nextBool();
        relayData.airMinusOpen = r.nextBool();
        relayData.prechargeOpen = r.nextBool();

        // IVT data
        IVTData ivtData = carData.ivtData;
        ivtData.current = r.nextDouble() * 2 - 1;
        ivtData.voltage1 = r.nextDouble();
        ivtData.voltage2 = r.nextDouble();
        ivtData.voltage3 = r.nextDouble();
      }
    }
  }

  Timer.periodic(Duration(milliseconds: 1000), f);
}
