import 'package:example/pages/home/home_page_item.dart';
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
            description:
                'Lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SimpleChartPage()),
            ),
          ),
          const HomePageItem(
            title: 'title',
            description: 'description',
          ),
        ],
      ),
    );
  }
}
