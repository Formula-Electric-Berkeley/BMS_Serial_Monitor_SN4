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
  static const double minCellTemperatureDischarge = -20;
  static const double maxCellTemperatureDischarge = 60;
  static const double minCellTemperatureCharge = 0;
  static const double maxCellTemperatureCharge = 45;

  // Serial
  static const String cellDataSerialId = 'cell';
  static const String relayDataSerialId = 'relay';
  static const String ivtDataSerialId = 'ivt';
  static const String chargerData1SerialId = 'charger1';
  static const String chargerData2SerialId = 'charger2';

  // Info table
  static const int infoTableRefreshRateMs = 50;
}
