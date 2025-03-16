part of 'chart_painter.dart';

extension Indicators on ChartPainter {
  void _drawIndicators(Size size, Canvas canvas, Rect chartArea) {
    for (var indicator in _chartData.series.indicators) {
      _drawIndicator(size, canvas, chartArea, indicator);
    }
  }

  void _drawIndicator(
      Size size, Canvas canvas, Rect chartArea, Indicator indicator) {
    final plotAreaTop = _chartStyle.chartPadding.top;
    final plotAreaBottom = 200;

    if (indicator.type > 0) {
      // TODO: include padding
      var yTop = _mainChartHeight +
          (_numIndicatorsBelowChartDrawn++ * _indicatorHeight);
      var yBottom = yTop + _indicatorHeight;

      canvas.drawLine(
          Offset(200, yTop.toDouble()),
          Offset(200, yBottom.toDouble()),
          Paint()
            ..color = indicator.color
            ..strokeWidth = 2);
    }

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
          (i++ * _spaceBetweenDivX + _chartStyle.chartPadding.left).toDouble();

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
