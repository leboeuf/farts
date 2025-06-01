part of 'chart_painter.dart';

extension Indicators on ChartPainter {
  void _drawIndicators(Size size, Canvas canvas, Rect chartArea) {
    for (var indicator in _chartData.series.indicators) {
      _drawIndicator(size, canvas, chartArea, indicator);
    }
  }

  void _drawIndicator(
    Size size,
    Canvas canvas,
    Rect chartArea,
    Indicator indicator,
  ) {
    double minValue;
    double maxValue;
    double plotAreaTop;
    double plotAreaBottom;

    if (indicator.type > 0) {
      minValue = indicator.data.reduce((a, b) => a < b ? a : b);
      maxValue = indicator.data.reduce((a, b) => a > b ? a : b);
      plotAreaTop = _mainChartHeight +
          _chartStyle.chartPadding.top +
          (_numIndicatorsBelowChartDrawn++ * _indicatorHeight);
      plotAreaBottom =
          plotAreaTop + _indicatorHeight - _chartStyle.chartPadding.bottom;

      if (_chartStyle.indicatorBorderThickness > 0) {
        canvas.drawRect(
            Rect.fromPoints(
              Offset(_chartStyle.chartPadding.left, plotAreaTop),
              Offset(_widthAvailableForData + _chartStyle.chartPadding.left,
                  plotAreaBottom),
            ),
            Paint()
              ..style = PaintingStyle.stroke
              ..color = _chartStyle.colors.indicatorBorderColor
              ..strokeWidth = _chartStyle.indicatorBorderThickness);
      }

      _drawText(
        size,
        canvas,
        indicator.name,
        _chartStyle.chartPadding.left + 2,
        plotAreaTop,
        indicator.color,
        12,
      );
    } else {
      minValue = _yAxisOverrideMin ?? _chartData.series.min;
      maxValue = _yAxisOverrideMax ?? _chartData.series.max;
      plotAreaTop = _chartStyle.chartPadding.top;
      plotAreaBottom =
          (_mainChartHeight - _chartStyle.bottomLegendHeight).toDouble();

      _drawText(
        size,
        canvas,
        indicator.name,
        _chartStyle.chartPadding.left + 2,
        _chartStyle.chartPadding.top + 2 + (_numMainIndicatorsDrawn++ * 14),
        indicator.color,
        12,
      );
    }

    // Draw each indicator value...
    var i = 0;
    var hasSeenNonZeroValue = false;
    var previousY = 0;
    for (var value in indicator.data) {
      if (value == 0 && !hasSeenNonZeroValue) {
        i++;
        continue;
      }

      // Get the Y position of the value.
      final y = _worldToScreen(
        minValue,
        maxValue,
        value,
        plotAreaTop,
        plotAreaBottom,
      );

      // Get the X position of the value.
      final x =
          (i++ * _spaceBetweenDivX + _chartStyle.chartPadding.left).toDouble();

      // Draw the value
      canvas.drawLine(
          Offset(x - _spaceBetweenDivX,
              (hasSeenNonZeroValue ? previousY : y).toDouble()),
          Offset(x, y.toDouble()),
          Paint()
            ..color = indicator.color
            ..strokeWidth = 2);

      hasSeenNonZeroValue = true;
      previousY = y;
    }
  }
}
