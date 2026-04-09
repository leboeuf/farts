part of 'chart_painter.dart';

extension Data on ChartPainter {
  void _drawData(Canvas canvas, Rect chartArea) {
    final plotAreaTop = _chartStyle.chartPadding.top;
    final plotAreaBottom =
        (_mainChartHeight - _chartStyle.bottomLegendHeight).toDouble();
    final minValue = _yAxisOverrideMin ?? _chartData.series.min;
    final maxValue = _yAxisOverrideMax ?? _chartData.series.max;
    final bodyWidth =
        max(1.0, _spaceBetweenDivX * _chartStyle.candlestickBodyWidthRatio);

    // Draw each tick...
    var i = 0;
    for (var tick in _chartData.series.ticks) {
      // Get the Y position of the top of the tick.
      final yPosHigh = _worldToScreen(
        minValue,
        maxValue,
        tick.high,
        plotAreaTop,
        plotAreaBottom,
      );

      // Get the Y position of the bottom of the tick.
      final yPosLow = _worldToScreen(
        minValue,
        maxValue,
        tick.low,
        plotAreaTop,
        plotAreaBottom,
      );

      // Get the X position of the tick.
      final x =
          (i++ * _spaceBetweenDivX + _chartStyle.chartPadding.left).toDouble();

      if (_chartStyle.showCandlesticks) {
        final isBullish = tick.close >= tick.open;
        final candleColor = isBullish
            ? _chartStyle.colors.bullColor
            : _chartStyle.colors.bearColor;

        // Draw wick.
        canvas.drawLine(
          Offset(x, yPosHigh.toDouble()),
          Offset(x, yPosLow.toDouble()),
          Paint()
            ..color = candleColor
            ..strokeWidth = 1,
        );

        final yPosOpen = _worldToScreen(
          minValue,
          maxValue,
          tick.open,
          plotAreaTop,
          plotAreaBottom,
        );

        final yPosClose = _worldToScreen(
          minValue,
          maxValue,
          tick.close,
          plotAreaTop,
          plotAreaBottom,
        );

        // Draw bdy.
        final bodyTop = min(yPosOpen, yPosClose).toDouble();
        final bodyBottom = max(yPosOpen, yPosClose).toDouble();
        final halfBody = bodyWidth / 2;
        final bodyRect = Rect.fromLTRB(
          x - halfBody,
          bodyTop,
          x + halfBody,
          max(bodyBottom, bodyTop + 1),
        );

        canvas.drawRect(
          bodyRect,
          Paint()
            ..color = candleColor
            ..style = PaintingStyle.fill,
        );
      } else {
        // Draw high-low line.
        canvas.drawLine(
          Offset(x, yPosHigh.toDouble()),
          Offset(x, yPosLow.toDouble()),
          Paint()
            ..color = _chartStyle.colors.lineColor
            ..strokeWidth = 2,
        );
      }
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
