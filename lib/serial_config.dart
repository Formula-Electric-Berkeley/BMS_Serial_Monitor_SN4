import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:serial_monitor/car_data.dart';
import 'package:serial_monitor/serial_monitor.dart';

class SerialConfig extends StatefulWidget {
  final CarData carData;

  const SerialConfig(this.carData, {super.key});

  @override
  State<SerialConfig> createState() => _SerialConfigState();
}

class _SerialConfigState extends State<SerialConfig> {
  List<String> portList = SerialMonitor.availablePorts;
  late String selectedPort = portList.first;
  int selectedBaudrate = SerialMonitor.baudrates.first;

  bool connected = false;
  SerialMonitor? serialMonitor;

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = TextButton.styleFrom(
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SerialConfigDropdown(
          items: portList,
          value: selectedPort,
          onChanged: (String? port) {
            if (port != null) {
              setState(() {
                selectedPort = port;
              });
            }
          },
        ),
        _SerialConfigDropdown(
          items: SerialMonitor.baudrates,
          value: selectedBaudrate,
          onChanged: (int? baudrate) {
            if (baudrate != null) {
              setState(() {
                selectedBaudrate = baudrate;
              });
            }
          },
        ),
        TextButton.icon(
          label: Text(serialMonitor == null ? 'Connect' : 'Disconnect'),
          icon: Icon(Icons.compare_arrows),
          onPressed: () {
            SerialMonitor? localSerialMonitor = serialMonitor;
            if (localSerialMonitor == null) {
              // Connect serial monitor
              localSerialMonitor = SerialMonitor(
                selectedPort,
                selectedBaudrate,
                widget.carData,
              );
            } else {
              // Disconnect serial monitor
              localSerialMonitor.close();
              localSerialMonitor = null;
            }
            setState(() {
              serialMonitor = localSerialMonitor;
            });
          },
          style: buttonStyle,
        ),
        TextButton.icon(
          label: Text('Refresh'),
          icon: Icon(Icons.refresh),
          onPressed: () {
            SerialMonitor.refreshPorts();
            setState(() {
              portList = SerialMonitor.availablePorts;
            });
          },
          style: buttonStyle,
        ),
      ],
    );
  }
}

class _SerialConfigDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T value;
  final ValueChanged<T?> onChanged;

  const _SerialConfigDropdown({
    required this.items,
    required this.value,
    required this.onChanged,
    super.key,
  });

  DropdownMenuItem<T> dropdownMenuItemOfItem(T item) {
    return DropdownMenuItem(value: item, child: Text(item.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        items: items.map(dropdownMenuItemOfItem).toList(),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
