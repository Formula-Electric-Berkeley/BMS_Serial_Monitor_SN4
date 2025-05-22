import 'dart:async';
import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class InfoLineChart extends StatefulWidget {
  final double Function() nextValue;
  final int numSeconds;
  final String yLabel;

  const InfoLineChart({
    super.key,
    required this.nextValue,
    required this.numSeconds,
    required this.yLabel,
  });

  @override
  State<InfoLineChart> createState() => _InfoLineChartState();
}

class _InfoLineChartState extends State<InfoLineChart> {
  final Queue<FlSpot> data = Queue();
  double currTime = 0;
  Timer? _updateTimer;

  _InfoLineChartState() {
    _updateTimer = Timer.periodic(Duration(seconds: 1), (_) {
      currTime++;
      double currValue = widget.nextValue();
      setState(() {
        data.addLast(FlSpot(currTime, currValue));
        if (data.length > widget.numSeconds) {
          data.removeFirst();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    Timer? updateTimer = _updateTimer;
    if (updateTimer != null) {
      updateTimer.cancel();
      _updateTimer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(color: Colors.orange, spots: data.toList()),
        ],
        titlesData: FlTitlesData(
          bottomTitles: const AxisTitles(
            axisNameWidget: Text('Time / s'),
            sideTitles: SideTitles(
              reservedSize: 30,
              showTitles: true,
              minIncluded: false,
              maxIncluded: false,
              interval: 5,
            ),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: Text(widget.yLabel),
            sideTitles: SideTitles(
              reservedSize: 50,
              showTitles: true,
              minIncluded: false,
              maxIncluded: false,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
      ),
    );
  }
}
