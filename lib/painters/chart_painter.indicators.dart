part of 'chart_painter.dart';

extension Indicators on ChartPainter {
  void _drawIndicators(Canvas canvas, Rect chartArea) {
    // TODO: draw indicators that are below the chart.
    // Maybe make each of them take 20% height, limit to 3 indicators.

    var indicatorsBelowChart = _chartData.series.indicators
        .where((x) => x.type > 0)
        .length; // TODO: drawData() also need to know, axes too, in order to know their height
    for (var indicator in _chartData.series.indicators) {
      _drawIndicator(canvas, chartArea, indicator);
    }
  }

  void _drawIndicator(Canvas canvas, Rect chartArea, Indicator indicator) {
    final plotAreaTop = _chartStyle.chartPadding.top;
    final plotAreaBottom = 200;
    final availableWidth = _calculateAvailableWidthForData(chartArea);

    // Calculate the space between each tick.
    final spaceBetweenDivX = availableWidth / _chartData.series.ticks.length;

    // Draw each tick...
    var i = 0;
    for (var value in indicator.data) {
      // Get the Y position of the top of the tick.
      final yPosHigh = _worldToScreen(
        _chartData.series,
        value,
        plotAreaTop.toInt(),
        plotAreaBottom,
      );

      // Get the Y position of the bottom of the tick.
      final yPosLow = _worldToScreen(
        _chartData.series,
        value,
        plotAreaTop.toInt(),
        plotAreaBottom,
      );

      // Get the X position of the tick.
      final x =
          (i++ * spaceBetweenDivX + _chartStyle.chartPadding.left).toDouble();

      // Draw the tick
      canvas.drawLine(
          Offset(x, yPosHigh.toDouble()),
          Offset(x, yPosLow + 1.toDouble()),
          Paint()
            ..color = indicator.color
            ..strokeWidth = 2);
    }
  }
}
