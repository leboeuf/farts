part of 'chart_painter.dart';

extension Events on ChartPainter {
  // Handles pan updates, e.g. for zooming or panning the chart.
  void onPanUpdate(DragUpdateDetails details) {
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
}
