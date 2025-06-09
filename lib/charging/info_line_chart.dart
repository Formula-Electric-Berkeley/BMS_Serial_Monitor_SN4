import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:serial_monitor/charging/info_time_series.dart';

class InfoLineChart extends StatefulWidget {
  final InfoTimeSeries timeSeriesData;
  final String yLabel;
  final BarAreaData? belowBarData;
  final BarAreaData? aboveBarData;

  const InfoLineChart({
    super.key,
    required this.timeSeriesData,
    required this.yLabel,
    this.belowBarData,
    this.aboveBarData,
  });

  @override
  State<InfoLineChart> createState() => _InfoLineChartState();
}

class _InfoLineChartState extends State<InfoLineChart> {
  Timer? _updateTimer;

  _InfoLineChartState() {
    _updateTimer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {});
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
    List<FlSpot> data = _buildData;
    double? minY;
    double? maxY;
    if (data.isNotEmpty) {
      Iterable<double> yValues = data.map((spot) => spot.y);
      minY = yValues.reduce(min);
      minY -= minY.abs() * 0.1;
      minY = min(0, minY);
      maxY = yValues.reduce(max);
      maxY += maxY.abs() * 0.1;
      maxY = max(0, maxY);
    }
    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        clipData: FlClipData.all(),
        lineBarsData: [
          LineChartBarData(
            color: Colors.orange,
            spots: data,
            belowBarData: widget.belowBarData,
            aboveBarData: widget.aboveBarData,
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: const AxisTitles(
            axisNameWidget: Text('Time / s'),
            sideTitles: SideTitles(
              reservedSize: 30,
              showTitles: true,
              minIncluded: false,
              maxIncluded: false,
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

  List<FlSpot> get _buildData =>
      widget.timeSeriesData.data.map((e) => FlSpot(e.time, e.value)).toList();
}
