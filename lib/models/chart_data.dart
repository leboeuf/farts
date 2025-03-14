import 'package:farts/models/tick_collection.dart';

class ChartData {
  late TickCollection series;

  ChartData({TickCollection? series}) {
    this.series = series ?? TickCollection([]);
  }
}
