import 'package:farts/models/chart_event_marker.dart';
import 'package:flutter/material.dart';

final List<ChartEventMarker> kFakeEventMarkersData = [
  ChartEventMarker(
    timestamp: DateTime.utc(2024, 4, 4),
    price: 518.0,
    color: Color(0xfff94144),
  ),
  ChartEventMarker(
    timestamp: DateTime.utc(2024, 5, 15),
    price: 529.7,
    color: Color(0xccf8961e),
  ),
  ChartEventMarker(
    timestamp: DateTime.utc(2024, 9, 19),
    price: 571.0,
    color: Color(0xcc277da1),
  ),
];
