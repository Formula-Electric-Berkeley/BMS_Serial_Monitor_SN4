import 'dart:async';
import 'dart:convert';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/constants.dart';

class SerialMonitor {
  static List<String> availablePorts = SerialPort.availablePorts;
  static final List<int> baudrates = [9600, 115200];

  final SerialPort _serialPort;
  late final StreamSubscription<String> _serialStream;
  final CarData _carData;

  /// Create a serial monitor at `port`.
  ///
  /// **Note:** Call `close()` to terminate serial connection.
  SerialMonitor(String port, int baudrate, this._carData) : _serialPort = SerialPort(port) {
    SerialPortReader reader = SerialPortReader(_serialPort);
    _serialPort.openRead();
    SerialPortConfig config = _serialPort.config;
    config.baudRate = baudrate;
    _serialPort.config = config;
    _read(reader);
  }

  /// Refresh `availablePorts`.
  static void refreshPorts() {
    availablePorts = SerialPort.availablePorts;
  }

  /// Close serial monitor.
  ///
  /// Once serial monitor is closed, it cannot be reopened.
  /// Create a new object to open a new serial monitor.
  ///
  /// **Note**: Call this function after you are finished
  /// with the serial monitor.
  void close() {
    _serialStream.cancel();
    _serialPort.dispose();
  }

  void _read(SerialPortReader reader) {
    _serialStream = reader.stream
        .map((data) => String.fromCharCodes(data))
        .transform(LineSplitter())
        .listen((String s) {
          _parse(s);
        });
  }

  void _parse(String s) {
    List<String> splitted = s.split(' ');
    if (splitted.isEmpty) return;
    switch (splitted[0]) {
      case 'cell':
        _storeCellData(splitted);
        break;
      default:
    }
  }

  void _storeCellData(List<String> data) {
    if (data.length != 5) return;

    // Bank
    int? bank = int.tryParse(data[1]);
    if (bank == null || bank < 0 || bank >= numBanks) return;

    // Cell
    int? cell = int.tryParse(data[2]);
    if (cell == null || cell < 0 || cell >= numCellsPerBank) return;

    // Voltage
    double? voltage = double.tryParse(data[3]);
    if (voltage == null) return;

    // Temperature
    double? temperature = double.tryParse(data[4]);
    if (temperature == null) return;

    // Store data
    CellData cellData = _carData.getCell(bank, cell);
    cellData.voltage = voltage;
    cellData.temperature = temperature;
  }
}
