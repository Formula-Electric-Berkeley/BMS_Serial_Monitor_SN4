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
  int voltage;
  int temperature;

  CellData({this.voltage = 0, this.temperature = 0});

  String get stringOfVoltage {
    return voltage.toStringAsFixed(voltageDecimalPrecision);
  }

  String get stringOfTemperature {
    return temperature.toStringAsFixed(temperatureDecimalPrecision);
  }
}
