import 'package:farts/farts.dart';

import '../chart_style.dart' show ChartStyle;
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
    var chartArea = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.clipRect(chartArea);

    // Draw background
    var bgGradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: _chartStyle.colors.backgroundColor,
    );
    canvas.drawRect(
        chartArea, Paint()..shader = bgGradient.createShader(chartArea));

    // Draw series
    canvas.drawLine(
        const Offset(20, 20),
        const Offset(90, 90),
        Paint()
          ..color = _chartStyle.colors.lineColor
          ..strokeWidth = 4);

    // Draw debug text
    _drawDebugText(size, canvas);
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
}
