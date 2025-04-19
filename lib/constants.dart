/// Global constants
abstract final class Constants {
  // Accumulator
  static const int numBanks = 7;
  static const int numCellsPerBank = 20;
  static const int voltageDecimalPrecision = 3;
  static const int currentDecimalPrecision = 3;
  static const int temperatureDecimalPrecision = 1;
  static const double minCellVoltage = 2.5;
  static const double maxCellVoltage = 4.2;

  // Serial
  static const String cellDataSerialId = 'cell';
  static const String relayDataSerialId = 'relay';
  static const String ivtDataSerialId = 'ivt';

  // Info table
  static const int infoTableRefreshRateMs = 50;
}
