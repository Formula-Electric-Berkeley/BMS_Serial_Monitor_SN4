import 'package:flutter/material.dart';
import 'package:serial_monitor/info_table/info_table.dart';
import 'package:serial_monitor/info_table/info_table_entry.dart';

/// [InfoTable] for relays.
class InfoTableRelay extends StatefulWidget {
  const InfoTableRelay({super.key});

  @override
  State<InfoTableRelay> createState() => _InfoTableRelayState();
}

class _InfoTableRelayState extends State<InfoTableRelay> {
  static const double entryWidth = 90;

  @override
  Widget build(BuildContext context) {
    return InfoTable(
      entries: [
        [
          InfoTableEntry(text: 'AIR+', width: entryWidth),
          InfoTableEntry(text: 'AIR-', width: entryWidth),
          InfoTableEntry(text: 'PC', width: entryWidth),
        ],
        [InfoTableEntry(), InfoTableEntry(), InfoTableEntry()],
      ],
    );
  }
}
