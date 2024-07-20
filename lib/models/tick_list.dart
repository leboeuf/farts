import 'package:farts/models/tick.dart';

/// Holds a list of ticks and memoizes its min and max values.
class TickList {
  List<Tick> _ticks;
  double? _min;
  double? _max;

  TickList(List<Tick> ticks)
      : _ticks = ticks,
        _min = null,
        _max = null;

  List<Tick> get ticks => _ticks;

  set ticks(List<Tick> newTicks) {
    _ticks = newTicks;
    _min = null;
    _max = null;
  }

  double get min {
    if (_min == null && _ticks.isNotEmpty) {
      _min = _ticks.map((tick) => tick.low).reduce((a, b) => a < b ? a : b);
    }
    return _min!;
  }

  double get max {
    if (_max == null && _ticks.isNotEmpty) {
      _max = _ticks.map((tick) => tick.high).reduce((a, b) => a > b ? a : b);
    }
    return _max!;
  }

  void add(Tick tick) {
    _ticks.add(tick);
    _min = null;
    _max = null;
  }

  void remove(Tick tick) {
    _ticks.remove(tick);
    _min = null;
    _max = null;
  }
}
