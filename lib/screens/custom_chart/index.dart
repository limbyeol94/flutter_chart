import 'package:flutter/material.dart';
import 'package:flutter_chart/screens/fl_chart/fl_bar_chart.dart';
import 'custom_chart_screen.dart';

class CustomChartIndex extends StatelessWidget {
  const CustomChartIndex({super.key});

  static const String routeName = '/custom_chart_index';

  @override
  Widget build(BuildContext context) {
    return const CustomChartContent();
  }
}
