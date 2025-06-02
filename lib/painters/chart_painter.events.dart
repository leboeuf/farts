part of 'chart_painter.dart';

extension Events on ChartPainter {
  // Handles pan updates, e.g. for zooming or panning the chart.
  void onPanUpdate(DragUpdateDetails details) {
    if (_isPerformingLongPress) {
      // If a long-press is in progress, ignore pan updates
      // to prevent conflicts with crosshair movement.
      return;
    }

    // Determine if the pan is vertical or horizontal.
    final isVertical = details.delta.dy.abs() > details.delta.dx.abs();

    if (isVertical) {
      // Vertical pan: adjust Y axis range.

      // Get current min and max for Y axis.
      final currentMax = _yAxisOverrideMax ?? _chartData.series.max;
      final currentMin = _yAxisOverrideMin ?? _chartData.series.min;

      // Compute the visible price range.
      final range = currentMax - currentMin;
      if (range == 0) return; // Prevent divide-by-zero

      // Normalize delta based on range (300 is an arbitrary sensitivity factor).
      final normalizedDelta = details.delta.dy / 300 * range;

      // Update Y axis values
      _yAxisOverrideMax = (currentMax + normalizedDelta).clamp(
        _chartData.series.min,
        double.infinity,
      );
      _yAxisOverrideMin = (currentMin - normalizedDelta).clamp(
        double.negativeInfinity,
        _chartData.series.max,
      );
    } else {
      // Horizontal pan: if the pan occured on the X axis labels section,
      //adjust X axis range. Otherwise, pan the chart.
      // TODO
    }

    // Notify listeners to repaint the chart.
    notifyListeners();
  }

  // Handles long-press events to show a crosshair on the chart.
  void onLongPressStart(LongPressStartDetails details) {
    _isPerformingLongPress = true;
    _crosshairPosition = _getSnappedCrosshair(details.localPosition);
    notifyListeners();
  }

  // Handles long-press move updates to update the crosshair position.
  void onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    _crosshairPosition = _getSnappedCrosshair(details.localPosition);
    notifyListeners();
  }

  void onLongPressUp() {
    _isPerformingLongPress = false;
  }

  /// Returns the Offset snapped to the nearest tick (X axis).
  Offset _getSnappedCrosshair(Offset localPosition) {
    var nearestIndex = 0;
    var minDist = double.infinity;

    for (var i = 0; i < _chartData.series.ticks.length; i++) {
      final tickX =
          (i * _spaceBetweenDivX + _chartStyle.chartPadding.left).toDouble();
      final dist = (localPosition.dx - tickX).abs();
      if (dist < minDist) {
        minDist = dist;
        nearestIndex = i;
      }
    }

    final snappedX =
        (nearestIndex * _spaceBetweenDivX + _chartStyle.chartPadding.left)
            .toDouble();

    return Offset(snappedX, localPosition.dy);
  }
}
