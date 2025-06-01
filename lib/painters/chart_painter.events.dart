part of 'chart_painter.dart';

extension Events on ChartPainter {
  // Handles pan updates, e.g. for zooming or panning the chart.
  void onPanUpdate(DragUpdateDetails details) {
    // Determine if the pan is vertical or horizontal.
    final isVertical = details.delta.dy.abs() > details.delta.dx.abs();

    if (isVertical) {
      // Vertical pan: adjust Y axis range.
      final delta = details.delta.dy;
      _yAxisOverrideMax = (_yAxisOverrideMax ?? _chartData.series.max) + delta;
      _yAxisOverrideMax = _yAxisOverrideMax!.clamp(
        _chartData.series.min,
        double.infinity,
      );
      _yAxisOverrideMin = (_yAxisOverrideMin ?? _chartData.series.min) - delta;
      _yAxisOverrideMin = _yAxisOverrideMin!.clamp(
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
