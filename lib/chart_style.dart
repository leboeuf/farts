import 'package:flutter/material.dart' show Color;

/// The color palette to use when drawing the chart.
class ChartColors {
  /// The background color. Specify multiple colors to create a gradient.
  List<Color> backgroundColor = const [Color(0xff18191d), Color(0xff18191d)];

  /// The color of the series.
  Color lineColor = const Color(0x554C86CD);

  /// The color to use for bullish data.
  Color bullColor = const Color(0xff4DAA90);

  /// The color to use for bearish data.
  Color bearColor = const Color(0xffC15466);
}

/// The visual style of the chart.
class ChartStyle {
  /// The color palette to use when drawing the chart.
  final ChartColors colors;

  /// Creates the visual style of the chart.
  ChartStyle({ChartColors? chartColors})
      : colors = chartColors ?? ChartColors();
}
