import 'package:flutter/material.dart';
import 'package:flutter_chart/screens/fl_chart/fl_bar_chart.dart';

class CustomChartIndex extends StatelessWidget {
  const CustomChartIndex({super.key});

  static const String routeName = '/custom_chart_index';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 10,
      children: [
        InkWell(
          onTap: () {
            // Navigator.pushNamed(context, FlBarChart.routeName);
          },
          child: const Text('custom Chart'),
        ),
      ],
    );
  }
}
