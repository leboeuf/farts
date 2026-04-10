import 'package:flutter/widgets.dart';

/// A circular marker rendered on top of the chart at a specific timestamp and price.
class ChartEventMarker {
  /// Marker timestamp. Used to compute the horizontal chart position.
  final DateTime timestamp;

  /// Marker price. Used to compute the vertical chart position.
  final double price;

  /// Marker color.
  final Color color;

  /// Marker diameter as a ratio of a candlestick body width.
  final double sizeRatio;

  /// Inner circle radius as a ratio of the outer radius.
  final double innerRadiusRatio;

  /// Outer circle stroke width as a ratio of the outer radius.
  final double strokeWidthRatio;

  const ChartEventMarker({
    required this.timestamp,
    required this.price,
    this.color = const Color(0xfff9c74f),
    this.sizeRatio = 8.0,
    this.innerRadiusRatio = 0.4,
    this.strokeWidthRatio = 0.28,
  });
}
