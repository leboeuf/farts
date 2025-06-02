library;

import 'package:farts/models/chart_data.dart';
import 'package:farts/painters/chart_painter.dart';
import 'package:flutter/widgets.dart';

import 'models/chart_style.dart';

/// A financial chart.
class Fart extends StatelessWidget {
  /// The size of the chart. To create a responsive chart, wrap it inside a
  /// LayoutBuilder and pass `constraints.biggest` for size.
  final Size _size;

  /// The visual style of the chart.
  final ChartStyle _chartStyle;

  /// The series to draw on the chart, including indicators.
  final ChartData _chartData;

  /// The CustomPainter that draws the chart and stores local state.
  ChartPainter? _chartPainter;

  /// Creates a Flutter chart.
  Fart(this._size, {super.key, ChartStyle? chartStyle, ChartData? chartData})
      : _chartStyle = chartStyle ?? ChartStyle(),
        _chartData = chartData ?? ChartData();

  @override
  Widget build(BuildContext context) {
    _chartPainter ??= ChartPainter(_chartStyle, _chartData);

    return RepaintBoundary(
      child: GestureDetector(
        onPanUpdate: (details) => _chartPainter!.onPanUpdate(details),
        onLongPressStart: (details) => _chartPainter!.onLongPressStart(details),
        onLongPressMoveUpdate: (details) =>
            _chartPainter!.onLongPressMoveUpdate(details),
        onLongPressUp: () => _chartPainter!.onLongPressUp(),
        child: CustomPaint(
          size: _size,
          painter: _chartPainter,
        ),
      ),
    );
  }
}
