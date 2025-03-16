part of 'chart_painter.dart';

extension Data on ChartPainter {
  void _drawData(Canvas canvas, Rect chartArea) {
    final plotAreaTop = _chartStyle.chartPadding.top;
    final plotAreaBottom = 200;
    final availableWidth = _calculateAvailableWidthForData(chartArea);

    // Calculate the space between each tick.
    final spaceBetweenDivX = availableWidth / _chartData.series.ticks.length;

    // Draw each tick...
    var i = 0;
    for (var tick in _chartData.series.ticks) {
      // Get the Y position of the top of the tick.
      final yPosHigh = _worldToScreen(
        _chartData.series,
        tick.high,
        plotAreaTop.toInt(),
        plotAreaBottom,
      );

      // Get the Y position of the bottom of the tick.
      final yPosLow = _worldToScreen(
        _chartData.series,
        tick.low,
        plotAreaTop.toInt(),
        plotAreaBottom,
      );

      // Get the X position of the tick.
      final x =
          (i++ * spaceBetweenDivX + _chartStyle.chartPadding.left).toDouble();

      // Draw the tick
      canvas.drawLine(
          Offset(x, yPosHigh.toDouble()),
          Offset(x, yPosLow.toDouble()),
          Paint()
            ..color = _chartStyle.colors.lineColor
            ..strokeWidth = 2);
    }
  }

  /// Calculate the width available to draw the ticks after
  /// removing the legend, padding, etc.
  double _calculateAvailableWidthForData(Rect chartArea) {
    return chartArea.width -
        _chartStyle.rightLegendWidth -
        _chartStyle.chartPadding.horizontal -
        _chartStyle.spacingBeforeYAxis;
  }

  /// Translates a [price] into a vertical screen coordinate.
  /// [yMin] is the top of the drawing area and [yMax] is the bottom.
  int _worldToScreen(
    TickCollection tickData,
    double price,
    int yMin,
    int yMax,
  ) {
    final range = tickData.max - tickData.min;

    final yProp = 1 - ((price - tickData.min) / range);
    final yOffset = yProp * (yMax - yMin);

    return yMin + yOffset.toInt();
  }
}
