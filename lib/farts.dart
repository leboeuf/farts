library farts;

import 'package:farts/painters/ChartPainter.dart';
import 'package:flutter/widgets.dart';

/// A Flutter chart
class Fart extends StatelessWidget {
  final Size _size;

  Fart(this._size, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: _size,
      painter: ChartPainter(),
    );
  }
}
