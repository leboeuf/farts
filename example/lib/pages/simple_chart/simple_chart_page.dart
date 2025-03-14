import 'package:example/fake_tick_data.dart';
import 'package:farts/farts.dart';
import 'package:farts/models/chart_data.dart';
import 'package:farts/models/tick_collection.dart';
import 'package:flutter/material.dart';

class SimpleChartPage extends StatelessWidget {
  const SimpleChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple chart'),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) => Fart(constraints.biggest,
              chartData: ChartData(series: TickCollection(kFakeTickData))),
        ),
      ),
    );
  }
}
