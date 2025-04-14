import 'package:flutter/material.dart';
import 'package:serial_monitor/info_table/info_table_entry.dart';

/// An information table widget.
///
/// Created using a grid of [Widget] entries.
///
/// It is recommended that entries are [InfoTableEntry] or
/// build using [InfoTableEntry].
class InfoTable extends StatelessWidget {
  final List<TableRow> _entries;

  InfoTable({required List<List<Widget>> entries, super.key})
    : _entries =
          entries.map((List<Widget> row) => TableRow(children: row)).toList();

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      defaultColumnWidth: IntrinsicColumnWidth(),
      children: _entries,
    );
  }
}
