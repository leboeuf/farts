import 'package:farts/models/tick.dart';
import 'package:farts/models/tick_list.dart';

class ChartData {
  late TickList series;

  ChartData({List<Tick>? series}) {
    this.series = TickList(series ?? []);
  }
}
