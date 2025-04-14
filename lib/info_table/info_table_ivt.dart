import 'package:flutter/material.dart';
import 'package:serial_monitor/info_table/info_table.dart';
import 'package:serial_monitor/info_table/info_table_entry.dart';

/// [InfoTable] for IVT data.
class InfoTableIVT extends StatefulWidget {
  const InfoTableIVT({super.key});

  @override
  State<InfoTableIVT> createState() => _InfoTableIVTState();
}

class _InfoTableIVTState extends State<InfoTableIVT> {
  static const double entryWidth = 90;

  @override
  Widget build(BuildContext context) {
    return InfoTable(
      entries: [
        [
          InfoTableEntry(text: 'I', width: entryWidth),
          InfoTableEntry(text: 'V1', width: entryWidth),
          InfoTableEntry(text: 'V2', width: entryWidth),
          InfoTableEntry(text: 'V3', width: entryWidth),
        ],
        [
          InfoTableEntry(),
          InfoTableEntry(),
          InfoTableEntry(),
          InfoTableEntry(),
        ],
      ],
    );
  }
}
