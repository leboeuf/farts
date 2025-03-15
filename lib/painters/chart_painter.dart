import 'package:farts/models/chart_data.dart';
import 'package:farts/models/indicator.dart';
import 'package:farts/models/tick_collection.dart';

import '../models/chart_style.dart' show ChartStyle;
import 'package:flutter/material.dart';

/// A [CustomPainter] implementation to draw financial charts.
class ChartPainter extends CustomPainter {
  /// The [ChartStyle] to use to draw the chart.
  final ChartStyle _chartStyle;

  /// Data to draw on the chart. Includes tick data, indicators and annotations.
  final ChartData _chartData;

  /// Stopwatch to measure drawing performance.
  final Stopwatch _stopwatch = Stopwatch();

  /// Creates a [ChartPainter] that draws a chart using the given [ChartStyle].
  ChartPainter(this._chartStyle, this._chartData);

  @override
  void paint(Canvas canvas, Size size) {
    _stopwatch.start();

    // Clip drawing area to chart bounds.
    final chartArea = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.clipRect(chartArea);

    _drawBackground(canvas, chartArea);

    if (_chartStyle.showXAxis) _drawXAxis(canvas, chartArea);
    if (_chartStyle.showYAxis) _drawYAxis(canvas, chartArea);

    _drawData(canvas, chartArea);
    _drawIndicators(canvas, chartArea);

    _stopwatch.stop();
    if (_chartStyle.showDebugText) _drawDebugText(size, canvas);
    _stopwatch.reset();
  }

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

  void _drawIndicators(Canvas canvas, Rect chartArea) {
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

  void _drawXAxis(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color = _chartStyle.colors.axisColor
      ..strokeWidth = 2;

    // Get the Y position of the X axis.
    final axisY = chartArea.bottom -
        _chartStyle.chartPadding.bottom -
        _chartStyle.bottomLegendHeight;

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
      final availableWidth = _calculateAvailableWidthForData(chartArea);
      final spaceBetweenDivX = availableWidth / _chartData.series.ticks.length;
      for (var i = 0; i < _chartData.series.ticks.length; ++i) {
        final x = i * spaceBetweenDivX + _chartStyle.chartPadding.left;
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
      ..strokeWidth = 2;

    // Get the X position of the Y axis.
    final axisX = chartArea.width -
        _chartStyle.rightLegendWidth -
        _chartStyle.chartPadding.right;
    final axisTopY = _chartStyle.chartPadding.top;
    final axisBottomY = chartArea.bottom -
        _chartStyle.chartPadding.bottom -
        _chartStyle.bottomLegendHeight -
        0;

    // Draw the Y axis.
    canvas.drawLine(
      Offset(axisX, axisTopY),
      Offset(axisX, axisBottomY),
      paint,
    );

    final max = _chartData.series.max;
    final min = _chartData.series.min;
    final range = max - min;
    final priceSteps = _findPriceScale(range);
    var currentPrice = (max / priceSteps).round() * priceSteps;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final labelStyle =
        TextStyle(color: _chartStyle.colors.axisLabelsColor, fontSize: 12);

    while (currentPrice >= min) {
      final y = _worldToScreen(_chartData.series, currentPrice.toDouble(),
              axisTopY.toInt(), axisBottomY.toInt())
          .toDouble();
      canvas.drawLine(
        Offset(axisX - _chartStyle.axisDashThickness, y),
        Offset(axisX + _chartStyle.axisDashThickness, y),
        paint,
      );

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

  void _drawBackground(Canvas canvas, Rect chartArea) {
    final bgGradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: _chartStyle.colors.backgroundColor,
    );
    canvas.drawRect(
        chartArea, Paint()..shader = bgGradient.createShader(chartArea));
  }

  void _drawDebugText(Size size, Canvas canvas) {
    const textStyle = TextStyle(
      color: Colors.red,
      fontSize: 30,
    );

    final textSpan = TextSpan(
      text:
          '${size.width.toStringAsFixed(0)} x ${size.height.toStringAsFixed(0)}\n${_stopwatch.elapsedMicroseconds} µs',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
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
