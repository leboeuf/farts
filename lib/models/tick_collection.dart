import 'package:farts/models/tick.dart';

/// Holds a list of ticks and memoizes its min and max values.
/// To improve drawing performance, the min and max values are recalculated
/// when the list of ticks changes rather than at drawing time.
class TickCollection {
  List<Tick> _ticks;
  double? _min;
  double? _max;

  TickCollection(List<Tick> ticks) : _ticks = ticks {
    _calculateMinMax();
  }

  List<Tick> get ticks => _ticks;

  set ticks(List<Tick> newTicks) {
    _ticks = newTicks;
    _calculateMinMax();
  }

  double get min => _min ?? 0;
  double get max => _max ?? 0;

  void add(Tick tick) {
    _ticks.add(tick);
    _updateMinMax(tick);
  }

  void remove(Tick tick) {
    _ticks.remove(tick);
    _calculateMinMax();
  }

  /// Recalculates the min and max values based on the whole list of ticks.
  void _calculateMinMax() {
    _min = null;
    _max = null;
    for (var tick in _ticks) {
      _updateMinMax(tick);
    }
  }

  /// Updates the min and max values if the given
  /// tick is above/below the current min/max.
  void _updateMinMax(Tick tick) {
    if (_min == null || tick.low < _min!) {
      _min = tick.low;
    }
    if (_max == null || tick.high > _max!) {
      _max = tick.high;
    }
  }
}
