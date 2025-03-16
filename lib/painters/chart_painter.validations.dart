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
    final textSpan = TextSpan(
      text: 'Error: $text',
      style: TextStyle(color: Colors.red),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final offset = Offset(0, 0);
    textPainter.paint(canvas, offset);
  }
}
