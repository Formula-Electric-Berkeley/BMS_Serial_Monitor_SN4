import 'dart:async';
import 'dart:convert';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/constants.dart';
import 'package:serial_monitor/globals.dart' as globals;

class SerialMonitor {
  List<String> _availablePorts = SerialPort.availablePorts;
  final CarData _carData;
  bool _connected = false;
  SerialPort? _serialPort;
  StreamSubscription<String>? _serialStream;

  /// The list of available serial ports to open.
  List<String> get availablePorts => _availablePorts;

  /// The list of available baudrates to configure serial port with.
  final List<int> availableBaudrates = const [9600, 115200];

  /// The serial port to open at.
  String? port;

  /// The baudrate to open serial port at.
  int? baudrate;

  /// The serial port open status.
  bool get connected => _connected;

  SerialMonitor(this._carData) {
    refresh();
  }

  /// Refresh list of available ports and baudrates.
  ///
  /// Method will reset `port` and `baudrate` if
  /// values are unfound in respective list.
  void refresh() {
    // Port
    _availablePorts = SerialPort.availablePorts;
    if (_availablePorts.isEmpty) {
      port = null;
    } else if (!_availablePorts.contains(port)) {
      port = _availablePorts.first;
    }

    // Baudrate
    if (availableBaudrates.isEmpty) {
      baudrate = null;
    } else if (!availableBaudrates.contains(baudrate)) {
      baudrate = availableBaudrates.first;
    }
  }

  /// Open serial port for reading.
  ///
  /// Serial port configuration is specified by
  /// `port` and `baudrate`.
  /// Serial port is successfully opened if `connected`.
  /// If serial port is already open, this method will
  /// do nothing.
  ///
  /// **Note**: Method may fail to open the specified
  /// serial port. Check `connected` after calling this
  /// method.
  void open() {
    // Do not re-open serial port
    if (_connected) {
      return;
    }

    // Check open request is valid
    String? selectedPort = port;
    int? selectedBaudrate = baudrate;
    if (selectedPort == null || selectedBaudrate == null) {
      return;
    }

    // Connect to serial port
    SerialPort serialPort = SerialPort(selectedPort);
    SerialPortReader reader = SerialPortReader(serialPort);
    bool connected = serialPort.openRead();
    if (!connected) {
      serialPort.dispose();
      return;
    }

    // Configure serial port
    SerialPortConfig config = serialPort.config;
    config.baudRate = selectedBaudrate;
    serialPort.config = config;

    // Update status
    _serialPort = serialPort;
    _serialStream = _read(reader);
    _connected = true;
  }

  /// Close serial port.
  ///
  /// If serial port is already closed, this method
  /// will do nothing. To re-open serial port,
  /// call `open` method.
  void close() {
    if (!_connected) {
      return;
    }

    // Terminate serial stream
    StreamSubscription<String>? serialStream = _serialStream;
    if (serialStream != null) {
      serialStream.cancel();
    }
    _serialStream = null;

    // Close serial port
    SerialPort? serialPort = _serialPort;
    if (serialPort != null) {
      serialPort.dispose();
    }
    _serialPort = null;

    _connected = false;
  }

  StreamSubscription<String> _read(SerialPortReader reader) {
    return reader.stream
        .map((data) => String.fromCharCodes(data))
        .transform(LineSplitter())
        .listen((String s) {
          _parse(s);
        });
  }

  /// Parse [String] read from serial port.
  void _parse(String s) {
    List<String> splitted = s.split(' ');
    if (splitted.isEmpty) return;
    switch (splitted[0]) {
      case Constants.cellDataSerialId:
        _storeCellData(splitted);
        break;
      case Constants.relayDataSerialId:
        _storeRelayData(splitted);
        break;
      case Constants.ivtDataSerialId:
        _storeIVTData(splitted);
        break;
      default:
    }
  }

  void _storeCellData(List<String> data) {
    if (data.length != 7) return;

    // Bank
    int? bank = int.tryParse(data[1]);
    if (bank == null || bank < 0 || bank >= Constants.numBanks) return;

    // Cell
    int? cell = int.tryParse(data[2]);
    if (cell == null || cell < 0 || cell >= Constants.numCellsPerBank) return;

    // Voltage
    double? voltage;
    if (!globals.useRedundantVoltage) {
      voltage = double.tryParse(data[3]);
    } else {
      voltage = double.tryParse(data[4]);
    }
    if (voltage == null) return;

    // Temperature
    double? temperature = double.tryParse(data[5]);
    if (temperature == null) return;

    bool? isBalancing = bool.tryParse(data[6]);
    if (isBalancing == null) return;

    // Store data
    CellData cellData = _carData.getCell(bank, cell);
    cellData.voltage = voltage;
    cellData.temperature = temperature;
    cellData.isBalancing = isBalancing;
  }

  void _storeRelayData(List<String> data) {
    if (data.length != 4) return;

    // AIR+
    bool? airPlusOpen = bool.tryParse(data[1]);
    if (airPlusOpen == null) return;

    // AIR-
    bool? airMinusOpen = bool.tryParse(data[2]);
    if (airMinusOpen == null) return;

    // Precharge
    bool? prechargeOpen = bool.tryParse(data[3]);
    if (prechargeOpen == null) return;

    // Store data
    RelayData relayData = _carData.relayData;
    relayData.airPlusOpen = airPlusOpen;
    relayData.airMinusOpen = airMinusOpen;
    relayData.prechargeOpen = prechargeOpen;
  }

  void _storeIVTData(List<String> data) {
    // Format: IVT i v1 v2 v3
    if (data.length != 5) return;
    
    // Current
    double? current = double.tryParse(data[1]);
    if (current == null) return;

    // Voltage 1
    double? voltage1 = double.tryParse(data[2]);
    if (voltage1 == null) return;

    // Voltage 2
    double? voltage2 = double.tryParse(data[3]);
    if (voltage2 == null) return;

    // Voltage 3
    double? voltage3 = double.tryParse(data[4]);
    if (voltage3 == null) return;

    // Store data
    IVTData ivtData = _carData.ivtData;
    ivtData.current = current;
    ivtData.voltage1 = voltage1;
    ivtData.voltage2 = voltage2;
    ivtData.voltage3 = voltage3;
  }
}
