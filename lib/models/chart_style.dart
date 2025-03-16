import 'package:flutter/widgets.dart';

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

  /// The color to use for axis lines.
  Color axisColor = const Color(0xff5e5e5e);

  /// The color to use for axis labels.
  Color axisLabelsColor = const Color(0xffcecece);

  /// The color to use for the border of indicators below the chart.
  Color indicatorBorderColor = const Color(0xff5e5e5e);
}

/// The visual style of the chart.
class ChartStyle {
  /// The color palette to use when drawing the chart.
  final ChartColors colors;

  /// Whether to display the X axis.
  final bool showXAxis;

  /// Whether to display the Y axis.
  final bool showYAxis;

  /// Whether to display debug text.
  final bool showDebugText;

  /// The width of the right legend (the price labels area).
  final int rightLegendWidth;

  /// The height of the bottom legend (the date labels area).
  final int bottomLegendHeight;

  /// The thickness of the main chart's axes.
  final double axisThickness;

  /// The thickness of the dashes on the axes (for each date or price level).
  final int axisDashThickness;

  /// The padding around the chart.
  final EdgeInsets chartPadding;

  /// The spacing between the chart's data area and the Y axis (right edge of the data area).
  /// Note: this is not in pixels, but rather a ratio based on the chart width.
  final int spacingBeforeYAxis;

  /// The spacing between the Y axis and its legend (the spacing before the prices).
  final int spacingBeforeYLegend;

  /// The height ratio of indicators displayed below the chart, relative to the main chart area.
  /// For example, a ratio of 0.2 means the indicator takes 20% of the total chart height.
  final double indicatorHeightRatio;

  /// Whether to display the indicator name in the top left corner.
  final bool showIndicatorName;

  /// The thickness of the border around the indicators below the chart.
  final double indicatorBorderThickness;

  /// Creates the visual style of the chart.
  ChartStyle({
    ChartColors? chartColors,
    this.showXAxis = true,
    this.showYAxis = true,
    this.showDebugText = true,
    this.rightLegendWidth = 50,
    this.bottomLegendHeight = 30,
    this.axisThickness = 2,
    this.axisDashThickness = 0,
    this.chartPadding = const EdgeInsets.all(8),
    this.spacingBeforeYAxis = 2,
    this.spacingBeforeYLegend = 5,
    this.indicatorHeightRatio = 0.2,
    this.showIndicatorName = true,
    this.indicatorBorderThickness = 2,
  }) : colors = chartColors ?? ChartColors();
}
