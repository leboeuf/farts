library farts;

import 'package:farts/painters/chart_painter.dart';
import 'package:flutter/widgets.dart';

import 'chart_style.dart';

/// A financial chart.
class Fart extends StatelessWidget {
  /// The size of the chart. To create a responsive chart, wrap it inside a
  /// LayoutBuilder and pass `constraints.biggest` for size.
  final Size _size;

  /// The visual style of the chart.
  final ChartStyle _chartStyle;

  /// Creates a Flutter chart.
  Fart(
    this._size, {
    super.key,
    ChartStyle? chartStyle,
  }) : _chartStyle = chartStyle ?? ChartStyle();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: _size,
      painter: ChartPainter(_chartStyle),
    );
  }
}
