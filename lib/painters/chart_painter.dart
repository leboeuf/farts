import 'package:farts/models/chart_data.dart';
import 'package:farts/models/tick_list.dart';

import '../models/chart_style.dart' show ChartStyle;
import 'package:flutter/material.dart';

/// A [CustomPainter] implementation to draw financial charts.
class ChartPainter extends CustomPainter {
  /// The [ChartStyle] to use to draw the chart.
  final ChartStyle _chartStyle;

  /// Data to draw on the chart. Includes tick data, indicators and annotations.
  final ChartData _chartData;

  /// Creates a [ChartPainter] that draws a chart using the given [ChartStyle].
  ChartPainter(this._chartStyle, this._chartData);

  @override
  void paint(Canvas canvas, Size size) {
    // Clip drawing area to chart bounds.
    final chartArea = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.clipRect(chartArea);

    _drawBackground(canvas, chartArea);

    _drawData(canvas, chartArea, _chartData);

    _drawDebugText(size, canvas);
  }

  void _drawData(Canvas canvas, Rect chartArea, ChartData chartData) {
    final spaceBetweenDivX = chartArea.width / _chartData.series.ticks.length;

    for (int i = 0; i < _chartData.series.ticks.length; ++i) {
      final plotAreaTop = 10;
      final plotAreaBottom = 400;
      final tick = _chartData.series.ticks.elementAt(i);
      final yPosHigh = _worldToScreen(
          _chartData.series, tick.high, plotAreaTop, plotAreaBottom);
      final yPosLow = _worldToScreen(
          _chartData.series, tick.low, plotAreaTop, plotAreaBottom);

      final x = (i * spaceBetweenDivX).toDouble();
      canvas.drawLine(
          Offset(x, yPosHigh.toDouble()),
          Offset(x, yPosLow.toDouble()),
          Paint()
            ..color = _chartStyle.colors.lineColor
            ..strokeWidth = 4);
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
          '${size.width.toStringAsFixed(0)} x ${size.height.toStringAsFixed(0)}',
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

  /// Translates a [price] into a vertical screen coordinate.
  /// [yMin] is the top of the drawing area and [yMax] is the bottom.
  int _worldToScreen(TickList tickData, double price, int yMin, int yMax) {
    final range = tickData.max - tickData.min;

    final yProp = 1 - ((price - tickData.min) / range);
    final yOffset = yProp * (yMax - yMin);

    return yMin + yOffset.toInt();
  }
}
