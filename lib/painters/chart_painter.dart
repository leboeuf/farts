import 'package:farts/models/chart_data.dart';
import 'package:farts/models/indicator.dart';
import 'package:farts/models/tick_collection.dart';

import '../models/chart_style.dart' show ChartStyle;
import 'package:flutter/material.dart';

part 'chart_painter.axes.dart';
part 'chart_painter.data.dart';
part 'chart_painter.debug.dart';
part 'chart_painter.indicators.dart';
part 'chart_painter.perf.dart';

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

  /// Number of indicators below the chart. Used to compute available height.
  late final int _numIndicatorsBelowChart;

  @override
  void paint(Canvas canvas, Size size) {
    _stopwatch.start();

    // Clip drawing area to chart bounds.
    final chartArea = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.clipRect(chartArea);

    _preprocess(chartArea);

    _drawBackground(canvas, chartArea);

    if (_chartStyle.showXAxis) _drawXAxis(canvas, chartArea);
    if (_chartStyle.showYAxis) _drawYAxis(canvas, chartArea);

    _drawData(canvas, chartArea);
    _drawIndicators(canvas, chartArea);

    _stopwatch.stop();
    if (_chartStyle.showDebugText) _drawDebugText(size, canvas);
    _stopwatch.reset();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
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
}
