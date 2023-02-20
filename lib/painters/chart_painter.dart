import '../chart_style.dart' show ChartStyle;
import 'package:flutter/material.dart';

/// A [CustomPainter] implementation to draw financial charts.
class ChartPainter extends CustomPainter {
  /// The [ChartStyle] to use to draw the chart.
  final ChartStyle _chartStyle;

  /// Creates a [ChartPainter] that draws a chart using the given [ChartStyle].
  ChartPainter(this._chartStyle);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    canvas.drawColor(_chartStyle.colors.backgroundColor[0], BlendMode.src);
    canvas.drawLine(
        const Offset(20, 20),
        const Offset(40, 40),
        Paint()
          ..color = _chartStyle.colors.lineColor
          ..strokeWidth = 4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
