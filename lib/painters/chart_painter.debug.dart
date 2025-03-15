part of 'chart_painter.dart';

extension Debug on ChartPainter {
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
}
