part of 'chart_painter.dart';

extension Validations on ChartPainter {
  /// Validates the inputs. If there is an error, it will be drawn
  /// on the canvas and `false` will be returned.
  bool _validate(Size size, Canvas canvas) {
    if (_numIndicatorsBelowChart < 0 || _numIndicatorsBelowChart > 3) {
      _drawError(size, canvas, 'Invalid number of indicators below chart.');
      return false;
    }

    if (_chartStyle.indicatorHeightRatio < 0 ||
        _chartStyle.indicatorHeightRatio > 1) {
      _drawError(size, canvas, 'Invalid indicator height ratio.');
      return false;
    }

    return true;
  }

  void _drawError(Size size, Canvas canvas, String text) {
    _drawText(size, canvas, 'Error: $text', 0, 0, Colors.red, 14);
  }
}
