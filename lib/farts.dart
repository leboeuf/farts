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

  /// Creates a Flutter chart.
  Fart(this._size, {super.key, ChartStyle? chartStyle, ChartData? chartData})
      : _chartStyle = chartStyle ?? ChartStyle(),
        _chartData = chartData ?? ChartData();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: _size,
        painter: ChartPainter(_chartStyle, _chartData),
      ),
    );
  }
}
