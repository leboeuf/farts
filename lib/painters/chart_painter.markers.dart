part of 'chart_painter.dart';

extension Markers on ChartPainter {
  /// Draws bullseye markers projected from marker timestamp/price to chart space.
  void _drawEventMarkers(Canvas canvas) {
    if (_chartData.eventMarkers.isEmpty || _chartData.series.ticks.isEmpty) {
      return;
    }

    final minValue = _yAxisOverrideMin ?? _chartData.series.min;
    final maxValue = _yAxisOverrideMax ?? _chartData.series.max;
    final plotAreaTop = _chartStyle.chartPadding.top;
    final plotAreaBottom =
        (_mainChartHeight - _chartStyle.bottomLegendHeight).toDouble();
    // Keep marker size tied to chart density, similar to candlestick sizing.
    final candleBodyWidth =
        max(1.0, _spaceBetweenDivX * _chartStyle.candlestickBodyWidthRatio);

    for (final marker in _chartData.eventMarkers) {
      final x = _timestampToScreenX(marker.timestamp);
      if (x == null) continue;

      final y = _worldToScreen(
        minValue,
        maxValue,
        marker.price,
        plotAreaTop,
        plotAreaBottom,
      ).toDouble();

      final markerDiameter = max(6.0, candleBodyWidth * marker.sizeRatio);
      final outerRadius = markerDiameter / 2;
      final innerRadius = min(
          outerRadius - 0.5, max(1.0, outerRadius * marker.innerRadiusRatio));
      final strokeWidth = max(1.0, outerRadius * marker.strokeWidthRatio);

      // Skip markers fully outside the main plot area.
      if (y < plotAreaTop - outerRadius || y > plotAreaBottom + outerRadius) {
        continue;
      }

      final outerPaint = Paint()
        ..color = marker.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      final innerPaint = Paint()
        ..color = marker.color
        ..style = PaintingStyle.fill;

      final center = Offset(x, y);
      canvas.drawCircle(center, outerRadius, outerPaint);
      canvas.drawCircle(center, innerRadius, innerPaint);
    }
  }

  /// Maps a timestamp to an X position, interpolating between neighboring ticks.
  double? _timestampToScreenX(DateTime timestamp) {
    final ticks = _chartData.series.ticks;
    if (ticks.isEmpty) return null;

    final targetMs = timestamp.toUtc().millisecondsSinceEpoch;
    final firstMs = ticks.first.timestamp.toUtc().millisecondsSinceEpoch;
    final lastMs = ticks.last.timestamp.toUtc().millisecondsSinceEpoch;

    if (targetMs <= firstMs) return _xAtIndex(0);
    if (targetMs >= lastMs) return _xAtIndex(ticks.length - 1);

    for (var i = 0; i < ticks.length - 1; i++) {
      final currentMs = ticks[i].timestamp.toUtc().millisecondsSinceEpoch;
      final nextMs = ticks[i + 1].timestamp.toUtc().millisecondsSinceEpoch;

      if (targetMs < currentMs || targetMs > nextMs) {
        continue;
      }

      final x0 = _xAtIndex(i);
      if (targetMs == currentMs || nextMs == currentMs) {
        return x0;
      }

      final x1 = _xAtIndex(i + 1);
      final ratio = (targetMs - currentMs) / (nextMs - currentMs);
      return x0 + (x1 - x0) * ratio;
    }

    return null;
  }

  /// Returns the X position of a tick index in the chart data area.
  double _xAtIndex(int index) {
    return index * _spaceBetweenDivX + _chartStyle.chartPadding.left;
  }
}
