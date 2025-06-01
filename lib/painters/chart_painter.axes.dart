part of 'chart_painter.dart';

extension Axes on ChartPainter {
  void _drawXAxis(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color = _chartStyle.colors.axisColor
      ..strokeWidth = _chartStyle.axisThickness;

    // Get the Y position of the X axis.
    final axisY =
        (_mainChartHeight - _chartStyle.bottomLegendHeight).toDouble();

    // Draw the X axis.
    canvas.drawLine(
      Offset(_chartStyle.chartPadding.left, axisY),
      Offset(
          chartArea.width -
              _chartStyle.rightLegendWidth -
              _chartStyle.chartPadding.right,
          axisY),
      paint,
    );

    // Draw the dashed lines.
    if (_chartStyle.axisDashThickness > 0) {
      for (var i = 0; i < _chartData.series.ticks.length; ++i) {
        final x = i * _spaceBetweenDivX + _chartStyle.chartPadding.left;
        canvas.drawLine(
          Offset(x, axisY - _chartStyle.axisDashThickness),
          Offset(x, axisY + _chartStyle.axisDashThickness),
          paint,
        );
      }
    }
  }

  void _drawYAxis(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color = _chartStyle.colors.axisColor
      ..strokeWidth = _chartStyle.axisThickness;

    // Get the X position of the Y axis.
    final axisX = chartArea.width -
        _chartStyle.rightLegendWidth -
        _chartStyle.chartPadding.right;
    final axisTopY = _chartStyle.chartPadding.top;
    final axisBottomY = _mainChartHeight - _chartStyle.bottomLegendHeight;

    // Draw the Y axis.
    canvas.drawLine(
      Offset(axisX, axisTopY),
      Offset(axisX, axisBottomY.toDouble()),
      paint,
    );

    final max = _yAxisOverrideMax ?? _chartData.series.max;
    final min = _yAxisOverrideMin ?? _chartData.series.min;
    final range = max - min;
    final priceSteps = _findPriceScale(range);
    var currentPrice = (max / priceSteps).round() * priceSteps;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final labelStyle =
        TextStyle(color: _chartStyle.colors.axisLabelsColor, fontSize: 12);

    while (currentPrice >= min) {
      final y = _worldToScreen(
        _chartData.series.min,
        _chartData.series.max,
        currentPrice,
        axisTopY,
        axisBottomY.toDouble(),
      ).toDouble();

      if (_chartStyle.axisDashThickness > 0) {
        canvas.drawLine(
          Offset(axisX - _chartStyle.axisDashThickness, y),
          Offset(axisX + _chartStyle.axisDashThickness, y),
          paint,
        );
      }

      // Show decimals only if the range is not too big.
      final formattedPrice = range > 80
          ? currentPrice.toStringAsFixed(0)
          : currentPrice.toStringAsFixed(2);
      final textSpan = TextSpan(text: formattedPrice, style: labelStyle);
      textPainter.text = textSpan;
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(axisX + _chartStyle.spacingBeforeYLegend,
              y - textPainter.height / 2));

      currentPrice -= priceSteps;
    }
  }

  /// Find the best price increments for the Y axis.
  double _findPriceScale(double priceRange) {
    const double minPriceIncrementsNb = 3;
    const double maxPriceIncrementsNb = 10;

    double nbSteps = 0;
    for (var increment = 0.0001; increment <= 100000; increment *= 10) {
      nbSteps = priceRange / increment;
      if (nbSteps >= minPriceIncrementsNb && nbSteps <= maxPriceIncrementsNb) {
        return increment;
      }
    }

    for (var increment = 0.00025; increment <= 250000; increment *= 10) {
      nbSteps = priceRange / increment;
      if (nbSteps >= minPriceIncrementsNb && nbSteps <= maxPriceIncrementsNb) {
        return increment;
      }
    }

    for (var increment = 0.0005; increment <= 500000; increment *= 10) {
      nbSteps = priceRange / increment;
      if (nbSteps >= minPriceIncrementsNb && nbSteps <= maxPriceIncrementsNb) {
        return increment;
      }
    }

    throw Exception("No increment found for price axis.");
  }
}
