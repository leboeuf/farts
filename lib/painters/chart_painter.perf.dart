part of 'chart_painter.dart';

extension Perf on ChartPainter {
  void _preprocess(Rect chartArea) {
    _numIndicatorsBelowChart =
        _chartData.series.indicators.where((i) => i.type > 0).length;
  }
}
