import 'dart:async';
import 'dart:convert';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class SerialMonitor {
  static List<String> availablePorts = SerialPort.availablePorts;
  static final List<int> baudrates = [9600, 115200];

  final SerialPort _serialPort;
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

// TODO: Remove function
void testSerial() {
  print(SerialMonitor.availablePorts);
  SerialMonitor serialMonitor = SerialMonitor('/dev/cu.usbmodem2103', 115200);
  ;
  Timer(Duration(seconds: 2), () {
    print('Timer finished!');
    serialMonitor.close();
    print('Serial port closed!');

    print('New serial port opening');
    SerialMonitor serialMonitor2 = SerialMonitor(
      '/dev/cu.usbmodem2103',
      115200,
    );
    print('New serial port opened');
    Timer(Duration(seconds: 2), () {
      print('Timer finished!');
      serialMonitor2.close();
      print('Serial port closed');
    });
  });
}
