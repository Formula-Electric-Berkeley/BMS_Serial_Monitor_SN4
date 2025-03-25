import 'dart:async';
import 'dart:convert';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class SerialMonitor {
  static List<String> availablePorts = SerialPort.availablePorts;
  static final List<int> baudrates = [9600, 115200];

  final SerialPort _serialPort;
  // late final SerialPortReader _serialReader;
  late final StreamSubscription<String> _serialStream;

  /// Create a serial monitor at `port`.
  ///
  /// **Note:** Call `close()` to terminate serial connection.
  SerialMonitor(String port, int baudrate) : _serialPort = SerialPort(port) {
    SerialPortReader reader = SerialPortReader(_serialPort);
    _serialPort.openRead();
    SerialPortConfig config = _serialPort.config;
    config.baudRate = baudrate;
    _serialPort.config = config;
    _read(reader);
  }

  static void refreshPorts() {
    availablePorts = SerialPort.availablePorts;
  }

  void _read(SerialPortReader reader) {
    _serialStream = reader.stream
        .map((data) => String.fromCharCodes(data))
        .transform(LineSplitter())
        .listen((String s) {
          print(s);
        });
  }

  void close() {
    _serialStream.cancel();
    _serialPort.dispose();
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter_libserialport/flutter_libserialport.dart';

// class SerialMonitor {
//   static List<String> availablePorts = SerialPort.availablePorts;

//   SerialPort serialPort;
//   late SerialPortReader serialReader;
//   late StreamSubscription<String> serialStream;

//   SerialMonitor(String port, int baudrate) : serialPort = SerialPort(port) {
//     // serialPort = SerialPort(port);
//     serialReader = SerialPortReader(serialPort);

//     serialPort.openRead();
//     SerialPortConfig config = serialPort.config;
//     config.baudRate = 115200;
//     serialPort.config = config;

//     // bool openRead = serialPort.openRead();
//     read();
//   }

//   static refreshPorts() {
//     availablePorts = SerialPort.availablePorts;
//   }

//   void read() {
//     Stream<List<int>> readStream = serialReader.stream;
//     serialStream = readStream
//         .map((data) => String.fromCharCodes(data))
//         .transform(LineSplitter())
//         .listen((String s) {
//           print(s);
//         });
//   }

//   void close() {
//     // serialPort.close();
//     serialStream.cancel();
//     serialPort.dispose();
//   }
// }
