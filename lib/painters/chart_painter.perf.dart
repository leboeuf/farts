part of 'chart_painter.dart';

extension Perf on ChartPainter {
  void _preprocess(Rect chartArea) {
    _numIndicatorsBelowChart =
        _chartData.series.indicators.where((i) => i.type > 0).length;

    _indicatorHeight =
        (_chartStyle.indicatorHeightRatio * chartArea.height).round();

    _mainChartHeight =
        (chartArea.height - (_numIndicatorsBelowChart * _indicatorHeight))
            .round();

    _widthAvailableForData = chartArea.width -
        _chartStyle.rightLegendWidth -
        _chartStyle.chartPadding.horizontal -
        _chartStyle.spacingBeforeYAxis;

    _spaceBetweenDivX = _widthAvailableForData / _chartData.series.ticks.length;
  }
}
