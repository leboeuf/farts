import 'dart:ui';

class Indicator {
  /// The name of the indicator. This can be displayed on the chart.
  final String name;

  /// The type of indicator. Used to determine how to draw the indicator.
  final int type;

  /// The data points of the indicator.
  final List<double> data;

  /// The color of the indicator.
  final Color color;

  const Indicator(this.name, this.type, this.color, this.data);
}
