import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/serial_monitor.dart';

// Serial data
final CarData carData = CarData();
final SerialMonitor serialMonitor = SerialMonitor(carData);

// Info table
bool useRedundantVoltage = false;
bool highlightCellLocation = true;
bool highlightInvalidVoltage = true;
bool highlightInvalidTemperature = true;
bool highlightBalancingCells = true;
