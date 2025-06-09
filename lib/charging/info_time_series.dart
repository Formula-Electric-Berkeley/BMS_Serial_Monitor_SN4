import 'dart:async';
import 'dart:collection';

class InfoTimeSeriesDataPoint {
  double time;
  double value;

  InfoTimeSeriesDataPoint({required this.time, required this.value});
}

/// Time series data.
class InfoTimeSeries {
  final Queue<InfoTimeSeriesDataPoint> _data = Queue();
  final double Function() _nextValue;

  int currTime = 0;

  InfoTimeSeries({required double Function() nextValue})
    : _nextValue = nextValue {
    Timer.periodic(Duration(seconds: 1), (Timer _) {
      if (_data.length == 30) {
        _data.removeFirst();
      }
      _data.addLast(
        InfoTimeSeriesDataPoint(time: currTime.toDouble(), value: _nextValue()),
      );
      currTime++;
    });
  }

  List<InfoTimeSeriesDataPoint> get data => _data.toList();

  void clear() {
    _data.clear();
    currTime = 0;
  }
}
