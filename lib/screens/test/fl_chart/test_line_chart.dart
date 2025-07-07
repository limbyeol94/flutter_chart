import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TestLineChart extends StatelessWidget {
  const TestLineChart({super.key});
  static const String routeName = '/test_line';
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(spots: [
            FlSpot(0, 0),
            FlSpot(1, 1.5),
            FlSpot(2, 2),
            FlSpot(3, 2.5),
            FlSpot(4, 3),
            FlSpot(5, 3.5),
            FlSpot(6, 4),
            FlSpot(7, 4.5),
            FlSpot(8, 5),
          ]),
        ],
      ),
    );
  }
}
