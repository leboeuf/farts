part of 'chart_painter.dart';

extension Data on ChartPainter {
  void _drawData(Canvas canvas, Rect chartArea) {
    final plotAreaTop = _chartStyle.chartPadding.top;

    // Draw each tick...
    var i = 0;
    for (var tick in _chartData.series.ticks) {
      // Get the Y position of the top of the tick.
      final yPosHigh = _worldToScreen(
        _yAxisOverrideMin ?? _chartData.series.min,
        _yAxisOverrideMax ?? _chartData.series.max,
        tick.high,
        plotAreaTop,
        (_mainChartHeight - _chartStyle.bottomLegendHeight).toDouble(),
      );

      // Get the Y position of the bottom of the tick.
      final yPosLow = _worldToScreen(
        _yAxisOverrideMin ?? _chartData.series.min,
        _yAxisOverrideMax ?? _chartData.series.max,
        tick.low,
        plotAreaTop,
        (_mainChartHeight - _chartStyle.bottomLegendHeight).toDouble(),
      );

      // Get the X position of the tick.
      final x =
          (i++ * _spaceBetweenDivX + _chartStyle.chartPadding.left).toDouble();

      // Draw the tick
      canvas.drawLine(
          Offset(x, yPosHigh.toDouble()),
          Offset(x, yPosLow.toDouble()),
          Paint()
            ..color = _chartStyle.colors.lineColor
            ..strokeWidth = 2);
    }
  }

  /// Translates a [price] into a vertical screen coordinate.
  /// [yMin] is the top of the drawing area and [yMax] is the bottom.
  int _worldToScreen(
    double minValue,
    double maxValue,
    double price,
    double yMin,
    double yMax,
  ) {
    final range = maxValue - minValue;

    final yProp = 1 - ((price - minValue) / range);
    final yOffset = yProp * (yMax - yMin);

    return (yMin + yOffset).toInt();
  }
}
