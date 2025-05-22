import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:serial_monitor/globals.dart' as globals;

class SerialPortSettings extends StatefulWidget {
  const SerialPortSettings({super.key});

  @override
  State<SerialPortSettings> createState() => _SerialPortSettingsState();
}

class _SerialPortSettingsState extends State<SerialPortSettings> {
  String? selectedPort;
  int? selectedBaudrate;

  @override
  void initState() {
    super.initState();
    selectedPort = globals.serialMonitor.port;
    selectedBaudrate = globals.serialMonitor.baudrate;
  }

  List<DropdownMenuItem<T>> dropdownMenuItemOfItemList<T>(List<T> items) {
    return items.map(dropdownMenuItemOfItem).toList();
  }

  DropdownMenuItem<T> dropdownMenuItemOfItem<T>(T item) {
    return DropdownMenuItem(value: item, child: Text(item.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 245, 245, 245),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            spacing: 25,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Port
              DropdownButton2<String>(
                value: selectedPort,
                isExpanded: true,
                items: dropdownMenuItemOfItemList(
                  globals.serialMonitor.availablePorts,
                ),
                onChanged:
                    globals.serialMonitor.connected
                        ? null
                        : (port) => {
                          if (port != null)
                            {setState(() => selectedPort = port)},
                        },
              ),

              // Baudrate
              DropdownButton2<int>(
                value: selectedBaudrate,
                isExpanded: true,
                items: dropdownMenuItemOfItemList(
                  globals.serialMonitor.availableBaudrates,
                ),
                onChanged:
                    globals.serialMonitor.connected
                        ? null
                        : (baudrate) => {
                          if (baudrate != null)
                            {setState(() => selectedBaudrate = baudrate)},
                        },
              ),

              // Refresh
              TextButton.icon(
                label: Text('Refresh'),
                icon: Icon(Icons.refresh),
                onPressed:
                    globals.serialMonitor.connected
                        ? null
                        : () {
                          globals.serialMonitor.refresh();
                          setState(() {
                            selectedPort = globals.serialMonitor.port;
                            selectedBaudrate = globals.serialMonitor.baudrate;
                          });
                        },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(),
                ),
              ),
            ],
          ),

          // Configure
          TextButton(
            onPressed:
                globals.serialMonitor.connected
                    ? null
                    : () {
                      globals.serialMonitor.port = selectedPort;
                      globals.serialMonitor.baudrate = selectedBaudrate;
                      Navigator.pop(context);
                    },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(),
            ),
            child: Text('Configure Serial Port'),
          ),
        ],
      ),
    );
  }
}
