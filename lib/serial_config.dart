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
  String selectedPort = SerialMonitor.availablePorts.first;
  int selectedBaudrate = SerialMonitor.baudrates.first;
  bool connected = false;
  late SerialMonitor serialMonitor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            items:
                SerialMonitor.baudrates
                    .map(
                      (baudrate) => DropdownMenuItem(
                        value: baudrate,
                        child: Text(baudrate.toString()),
                      ),
                    )
                    .toList(),
            value: selectedBaudrate,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedBaudrate = value;
                });
              }
            },
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            items:
                SerialMonitor.availablePorts
                    .map(
                      (port) =>
                          DropdownMenuItem(value: port, child: Text(port)),
                    )
                    .toList(),
            value: selectedPort,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedPort = value;
                });
              }
            },
          ),
        ),
        TextButton.icon(
          onPressed: () {
            if (connected) {
              serialMonitor.close();
            } else {
              serialMonitor = SerialMonitor(
                selectedPort,
                selectedBaudrate,
                widget.carData,
              );
            }
            setState(() {
              connected = !connected;
            });
          },
          label: Text(connected ? 'Disconnect' : 'Connect'),
          icon: Icon(Icons.compare_arrows_outlined),
          style: TextButton.styleFrom(shape: RoundedRectangleBorder()),
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              // TODO: Manually update lists in set state.
              //       Current solution is not robust.
              SerialMonitor.refreshPorts();
            });
          },
          label: Text('Refresh'),
          icon: Icon(Icons.refresh),
          style: TextButton.styleFrom(shape: RoundedRectangleBorder()),
        ),
      ],
    );
  }
}
