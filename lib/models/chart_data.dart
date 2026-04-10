import 'package:farts/models/tick_collection.dart';
import 'package:farts/models/chart_event_marker.dart';

class ChartData {
  late TickCollection series;
  late List<ChartEventMarker> eventMarkers;

  ChartData({TickCollection? series, List<ChartEventMarker>? eventMarkers}) {
    this.series = series ?? TickCollection([]);
    this.eventMarkers = eventMarkers ?? [];
  }
}
