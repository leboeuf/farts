import 'package:example/pages/home/home_page_item.dart';
import 'package:example/pages/candlestick_chart/candlestick_chart_page.dart';
import 'package:example/pages/simple_chart/simple_chart_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HomePageItem(
            title: 'Simple chart',
            description: 'A simple chart with default parameters.',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SimpleChartPage()),
            ),
          ),
          HomePageItem(
            title: 'Candlestick chart',
            description:
                'Displays OHLC candles with bullish and bearish body colors.',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CandlestickChartPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
