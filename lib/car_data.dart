import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
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
  CellData getCell(int bank, int cell) =>
      _cells[bank * Constants.numCellsPerBank + cell];

  /// Get bank statistics.
  BankData getBank(int bank) => _banks[bank];

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
    double minVoltage = double.infinity;
    double maxVoltage = double.negativeInfinity;
    double minTemperature = double.infinity;
    double maxTemperature = double.negativeInfinity;

    for (int cell = 0; cell < Constants.numCellsPerBank; cell++) {
      CellData cellData = getCell(bank, cell);

      // Accumulate cell voltage
      if (cellData.isVoltageSet && !cellData.disableVoltage) {
        totalVoltage += cellData.voltage;
        numVoltageCells++;
        minVoltage = min(minVoltage, cellData.voltage);
        maxVoltage = max(maxVoltage, cellData.voltage);
      }

      // Accumulate cell temperature
      if (cellData.isTemperatureSet && !cellData.disableTemperature) {
        totalTemperature += cellData.temperature;
        numTemperatureCells++;
        minTemperature = min(minTemperature, cellData.temperature);
        maxTemperature = max(maxTemperature, cellData.temperature);
      }
    }

    // Update bank data
    BankData bankData = _banks[bank];
    bankData.totalVoltage = totalVoltage;
    bankData.totalTemperature = totalTemperature;
    bankData.numVoltageCells = numVoltageCells;
    bankData.numTemperatureCells = numTemperatureCells;
    bankData.minVoltage = numVoltageCells > 0 ? minVoltage : null;
    bankData.maxVoltage = numVoltageCells > 0 ? maxVoltage : null;
    bankData.minTemperature = numTemperatureCells > 0 ? minTemperature : null;
    bankData.maxTemperature = numTemperatureCells > 0 ? maxTemperature : null;
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
    double minVoltage = double.infinity;
    double maxVoltage = double.negativeInfinity;
    double minTemperature = double.infinity;
    double maxTemperature = double.negativeInfinity;

    for (BankData bankData in _banks) {
      // Accumulate bank voltage
      totalVoltage += bankData.totalVoltage;
      numVoltageCells += bankData.numVoltageCells;
      minVoltage = min(minVoltage, bankData.minVoltage ?? double.infinity);
      maxVoltage = max(
        maxVoltage,
        bankData.maxVoltage ?? double.negativeInfinity,
      );

      // Accumulate bank temperature
      totalTemperature += bankData.totalTemperature;
      numTemperatureCells += bankData.numTemperatureCells;
      minTemperature = min(
        minTemperature,
        bankData.minTemperature ?? double.infinity,
      );
      maxTemperature = max(
        maxTemperature,
        bankData.maxTemperature ?? double.negativeInfinity,
      );
    }

    // Store data
    packData.totalVoltage = totalVoltage;
    packData.totalTemperature = totalTemperature;
    packData.numVoltageCells = numVoltageCells;
    packData.numTemperatureCells = numTemperatureCells;
    packData.minVoltage = numVoltageCells > 0 ? minVoltage : null;
    packData.maxVoltage = numVoltageCells > 0 ? maxVoltage : null;
    packData.minTemperature = numTemperatureCells > 0 ? minTemperature : null;
    packData.maxTemperature = numTemperatureCells > 0 ? maxTemperature : null;
  }

  /// Reset all statistics.
  void clear() {
    for (CellData cellData in _cells) {
      cellData.clear();
    }
    relayData.clear();
    ivtData.clear();
  }

  /// Enable all cell voltage and temperature readings.
  void enable() {
    for (CellData cellData in _cells) {
      cellData.enable();
    }
  }
}

/// Cell-related statistics.
class CellData {
  static const double _defaultVoltage = 0;
  static const double _defaultTemperature = 0;
  static const bool _defaultIsBalancing = false;

  double? _voltage;
  bool disableVoltage = false;
  double? _temperature;
  bool disableTemperature = false;
  bool? _isBalancing;

  double get voltage => (_voltage ?? _defaultVoltage);
  set voltage(double value) => _voltage = value;
  bool get isVoltageSet => _voltage != null;
  String get stringOfVoltage =>
      voltage.toStringAsFixed(Constants.voltageDecimalPrecision);
  bool get isUnderVoltage => voltage < Constants.minCellVoltage;
  bool get isOverVoltage => voltage > Constants.maxCellVoltage;

  double get temperature => (_temperature ?? _defaultTemperature);
  set temperature(double value) => _temperature = value;
  bool get isTemperatureSet => _temperature != null;
  String get stringOfTemperature =>
      temperature.toStringAsFixed(Constants.temperatureDecimalPrecision);
  bool get isUnderTemperature =>
      temperature <
      (globals.charging
          ? Constants.minCellTemperatureCharge
          : Constants.minCellTemperatureDischarge);
  bool get isOverTemperature =>
      temperature >
      (globals.charging
          ? Constants.maxCellTemperatureCharge
          : Constants.maxCellTemperatureDischarge);

  bool get isBalancing => (_isBalancing ?? _defaultIsBalancing);
  set isBalancing(bool value) => _isBalancing = value;
  bool get isBalancingSet => _isBalancing != null;

  /// Clear cell statistics.
  void clear() {
    _voltage = null;
    _temperature = null;
    _isBalancing = null;
  }

  /// Enable voltage and temperature readings.
  void enable() {
    disableVoltage = false;
    disableTemperature = false;
  }
}

/// Bank-related statistics.
class BankData {
  double totalVoltage = 0;
  double totalTemperature = 0;
  int numVoltageCells = 0;
  int numTemperatureCells = 0;
  double? minVoltage;
  double? maxVoltage;
  double? minTemperature;
  double? maxTemperature;

  double get _averageVoltage => totalVoltage / numVoltageCells;
  double get _averageTemperature => totalTemperature / numTemperatureCells;

  String get stringOfTotalVoltage =>
      _stringOfVoltage(numVoltageCells != 0 ? totalVoltage : null);
  String get stringOfAverageVoltage =>
      _stringOfVoltage(numVoltageCells != 0 ? _averageVoltage : null);
  String get stringOfAverageTemperature => _stringOfTemperature(
    numTemperatureCells != 0 ? _averageTemperature : null,
  );
  String get stringOfMinVoltage => _stringOfVoltage(minVoltage);
  String get stringOfMaxVoltage => _stringOfVoltage(maxVoltage);
  String get stringOfMinTemperature => _stringOfTemperature(minTemperature);
  String get stringOfMaxTemperature => _stringOfTemperature(maxTemperature);

  String _stringOfVoltage(double? value) => switch (value) {
    double d => d.toStringAsFixed(Constants.voltageDecimalPrecision),
    _ => '-',
  };

  String _stringOfTemperature(double? value) => switch (value) {
    double d => d.toStringAsFixed(Constants.temperatureDecimalPrecision),
    _ => '-',
  };
}

/// Pack-related statistics.
class PackData extends BankData {}

/// Relay state.
class RelayData {
  bool? airPlusOpen;
  bool? airMinusOpen;
  bool? prechargeOpen;

  String get stringOfAirPlus => _stringOfRelay(airPlusOpen);
  String get stringOfAirMinus => _stringOfRelay(airMinusOpen);
  String get stringOfPrecharge => _stringOfRelay(prechargeOpen);

  String _stringOfRelay(bool? open) => switch (open) {
    true => 'Open',
    false => 'Close',
    _ => '-',
  };

  void clear() {
    airPlusOpen = null;
    airMinusOpen = null;
    prechargeOpen = null;
  }
}

/// IVT data.
class IVTData {
  double? _current;
  double? _voltage1;
  double? _voltage2;
  double? _voltage3;

  set current(double value) => _current = value;
  set voltage1(double value) => _voltage1 = value;
  set voltage2(double value) => _voltage2 = value;
  set voltage3(double value) => _voltage3 = value;

  String get stringOfCurrent => _stringOfDouble(_current);
  String get stringOfVoltage1 => _stringOfDouble(_voltage1);
  String get stringOfVoltage2 => _stringOfDouble(_voltage2);
  String get stringOfVoltage3 => _stringOfDouble(_voltage3);

  void clear() {
    _current = null;
    _voltage1 = null;
    _voltage2 = null;
    _voltage3 = null;
  }

  String _stringOfDouble(double? value) =>
      (value != null)
          ? value.toStringAsFixed(Constants.voltageDecimalPrecision)
          : '-';
}

/// Randomize global [CarData] struct.
///
/// Used to test GUI by generating random data.
VoidCallback randomizeCarData() {
  CarData carData = globals.carData;
  Random r = Random();

  void f() {
    for (int bank = 0; bank < Constants.numBanks; bank++) {
      for (int cell = 0; cell < Constants.numCellsPerBank; cell++) {
        // Cell data
        CellData cellData = carData.getCell(bank, cell);
        if (!globals.useRedundantVoltage) {
          cellData._voltage = r.nextDouble() * 1.8 + 2.45;
        } else {
          cellData._voltage = 3;
        }
        cellData._temperature = r.nextDouble() * 90 - 25;
        cellData._isBalancing = r.nextDouble() > 0.9;

        // Relay data
        RelayData relayData = carData.relayData;
        relayData.airPlusOpen = r.nextBool();
        relayData.airMinusOpen = r.nextBool();
        relayData.prechargeOpen = r.nextBool();

        // IVT data
        IVTData ivtData = carData.ivtData;
        ivtData._current = r.nextDouble() * 2 - 1;
        ivtData._voltage1 = r.nextDouble();
        ivtData._voltage2 = r.nextDouble();
        ivtData._voltage3 = r.nextDouble();
      }
    }
  }

  return f;
}
