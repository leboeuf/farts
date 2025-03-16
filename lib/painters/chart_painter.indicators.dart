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

    if (indicator.type > 0) {
      // TODO: include padding
      var yTop = _mainChartHeight +
          (_numIndicatorsBelowChartDrawn++ * _indicatorHeight);
      var yBottom = yTop + _indicatorHeight;

      canvas.drawRect(
          Rect.fromPoints(
            Offset(0, yTop.toDouble()),
            Offset(_widthAvailableForData, yBottom.toDouble()),
          ),
          Paint()
            ..style = PaintingStyle.stroke
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
        _mainChartHeight - _chartStyle.bottomLegendHeight,
      );

      // Get the Y position of the bottom of the tick.
      final yPosLow = _worldToScreen(
        _chartData.series,
        value,
        plotAreaTop.toInt(),
        _mainChartHeight - _chartStyle.bottomLegendHeight,
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
