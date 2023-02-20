library farts;

import 'package:farts/painters/ChartPainter.dart';
import 'package:flutter/widgets.dart';

/// A Flutter chart
class Fart extends StatelessWidget {
  const Fart({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 200),
      painter: ChartPainter(),
    );
  }
}
