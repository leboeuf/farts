part of 'chart_painter.dart';

extension Crosshair on ChartPainter {
  void _drawCrosshair(Canvas canvas, Rect chartArea) {
    final paint = Paint()
      ..color = _chartStyle.colors.crosshairColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw dashed vertical line.
    _drawDashedLine(
      canvas,
      Offset(_crosshairPosition!.dx, chartArea.top),
      Offset(_crosshairPosition!.dx, chartArea.bottom),
      paint,
    );

    // Draw dashed horizontal line.
    _drawDashedLine(
      canvas,
      Offset(chartArea.left, _crosshairPosition!.dy),
      Offset(chartArea.right, _crosshairPosition!.dy),
      paint,
    );

    // Draw price label at the right of the horizontal crosshair line.
    final max = _yAxisOverrideMax ?? _chartData.series.max;
    final min = _yAxisOverrideMin ?? _chartData.series.min;
    final axisTopY = _chartStyle.chartPadding.top;
    final axisBottomY = _mainChartHeight - _chartStyle.bottomLegendHeight;

    // Convert screen Y to price.
    var price = min +
        (max - min) *
            (axisBottomY - _crosshairPosition!.dy) /
            (axisBottomY - axisTopY);

    // Format price.
    final priceLabel =
        (max - min) > 80 ? price.toStringAsFixed(0) : price.toStringAsFixed(2);

    // Draw price label background.
    final priceTextStyle = TextStyle(
      color: _chartStyle.colors.axisLabelsColor,
      fontSize: 12,
      backgroundColor: Colors.black,
    );
    final priceTextSpan = TextSpan(text: priceLabel, style: priceTextStyle);
    final priceTextPainter = TextPainter(
      text: priceTextSpan,
      textDirection: TextDirection.ltr,
    );
    priceTextPainter.layout();

    final priceLabelX = chartArea.right - priceTextPainter.width - 4;
    final priceLabelY = _crosshairPosition!.dy - priceTextPainter.height / 2;

    var priceLabelOffset = Offset(priceLabelX, priceLabelY);
    priceTextPainter.paint(canvas, priceLabelOffset);

    // Draw date/time label at the bottom of the vertical crosshair line.
    var nearestIndex = 0;
    var minDist = double.infinity;
    for (var i = 0; i < _chartData.series.ticks.length; i++) {
      final tickX =
          (i * _spaceBetweenDivX + _chartStyle.chartPadding.left).toDouble();
      final dist = (_crosshairPosition!.dx - tickX).abs();
      if (dist < minDist) {
        minDist = dist;
        nearestIndex = i;
      }
    }

    final dateValue =
        _chartData.series.ticks[nearestIndex].timestamp.toString();

    final dateTextStyle = TextStyle(
      color: _chartStyle.colors.axisLabelsColor,
      fontSize: 12,
      backgroundColor: Colors.black,
    );
    final dateTextSpan = TextSpan(text: dateValue, style: dateTextStyle);
    final dateTextPainter = TextPainter(
      text: dateTextSpan,
      textDirection: TextDirection.ltr,
    );
    dateTextPainter.layout();

    final dateLabelX = _crosshairPosition!.dx - dateTextPainter.width / 2;
    final dateLabelY =
        (_mainChartHeight - _chartStyle.bottomLegendHeight + 2).toDouble();

    final dateLabelOffset = Offset(dateLabelX, dateLabelY);
    dateTextPainter.paint(canvas, dateLabelOffset);
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint,
      {double dashWidth = 5, double dashSpace = 5}) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = sqrt(dx * dx + dy * dy);
    final dashCount = (distance / (dashWidth + dashSpace)).floor();
    final deltaX = dx / distance;
    final deltaY = dy / distance;

    var x = start.dx, y = start.dy;
    for (var i = 0; i < dashCount; ++i) {
      final x2 = x + deltaX * dashWidth;
      final y2 = y + deltaY * dashWidth;

      canvas.drawLine(Offset(x, y), Offset(x2, y2), paint);

      x += deltaX * (dashWidth + dashSpace);
      y += deltaY * (dashWidth + dashSpace);
    }
  }
}
