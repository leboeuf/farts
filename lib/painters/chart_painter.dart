import 'dart:math';

import 'package:farts/models/chart_data.dart';
import 'package:farts/models/indicator.dart';

import '../models/chart_style.dart' show ChartStyle;
import 'package:flutter/material.dart';

part 'chart_painter.axes.dart';
part 'chart_painter.crosshair.dart';
part 'chart_painter.data.dart';
part 'chart_painter.debug.dart';
part 'chart_painter.events.dart';
part 'chart_painter.indicators.dart';
part 'chart_painter.perf.dart';
part 'chart_painter.validations.dart';

/// A [CustomPainter] implementation to draw financial charts.
class ChartPainter extends CustomPainter with ChangeNotifier {
  /// The [ChartStyle] to use to draw the chart.
  final ChartStyle _chartStyle;

  /// Data to draw on the chart. Includes tick data, indicators and annotations.
  final ChartData _chartData;

  /// Stopwatch to measure drawing performance.
  final Stopwatch _stopwatch = Stopwatch();

  /// Creates a [ChartPainter] that draws a chart using the given [ChartStyle].
  ChartPainter(this._chartStyle, this._chartData);

  /// The number of indicators below the chart. Used to compute available height.
  int _numIndicatorsBelowChart = 0;

  /// The counter of the number of indicators below the chart that have been drawn.
  int _numIndicatorsBelowChartDrawn = 0;

  /// The counter of the number of indicators in the main chart that have been drawn.
  int _numMainIndicatorsDrawn = 0;

  /// The height of the main chart area (above the indicators).
  int _mainChartHeight = 0;

  /// The height of each indicator below the chart.
  int _indicatorHeight = 0;

  /// The width available to draw the data after removing the legend, padding, etc.
  double _widthAvailableForData = 0;

  /// The space between each tick on the X axis.
  double _spaceBetweenDivX = 0;

  /// The max value to use when calculating the Y axis range.
  /// By default, the Y axis range is determined by the minimum and maximum values
  /// present in the chart data. Howerver, if the user performs a pan gesture on the Y axis,
  /// this value is set to allow manual adjustment of the visible range.
  double? _yAxisOverrideMax;

  /// The min value to use when calculating the Y axis range.
  /// By default, the Y axis range is determined by the minimum and maximum values
  /// present in the chart data. However, if the user performs a pan gesture on the Y axis,
  /// this value is set to allow manual adjustment of the visible range.
  double? _yAxisOverrideMin;

  /// The position of the crosshair on the chart.
  /// This is set when the user performs a long-press gesture
  /// on the chart and updates as they move their finger.
  Offset? _crosshairPosition;

  /// Whether the user is currently performing a long-press gesture.
  bool _isPerformingLongPress = true;

  /// The position where the drag gesture started.
  /// This is used to determine if the user is trying to pan the chart
  /// or if they are trying to move the crosshair.
  Offset? _dragStartPosition;

  @override
  void paint(Canvas canvas, Size size) {
    _stopwatch.start();

    // Clip drawing area to chart bounds.
    final chartArea = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.clipRect(chartArea);

    _preprocess(chartArea);

    if (!_validate(size, canvas)) {
      return;
    }

    _drawBackground(canvas, chartArea);

    if (_chartStyle.showXAxis) _drawXAxis(canvas, chartArea);
    if (_chartStyle.showYAxis) _drawYAxis(canvas, chartArea);

    _drawData(canvas, chartArea);
    _drawIndicators(size, canvas, chartArea);

    if (_crosshairPosition != null) _drawCrosshair(canvas, chartArea);

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

  void _drawText(Size size, Canvas canvas, String text, double x, double y,
      Color color, double fontSize) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(color: color, fontSize: fontSize),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final offset = Offset(x, y);
    textPainter.paint(canvas, offset);
  }
}
