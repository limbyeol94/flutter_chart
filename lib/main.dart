import 'package:flutter/material.dart';
import 'package:flutter_chart/index.dart';
import 'package:flutter_chart/common/widgets/layout.dart';
import 'package:flutter_chart/screens/custom_chart/index.dart';
import 'package:flutter_chart/screens/fl_chart/fl_bar_chart.dart';
import 'package:flutter_chart/screens/fl_chart/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        Index.routeName: (context) => Layout(child: const Index()),
        FlChartIndex.routeName: (context) =>
            Layout(child: const FlChartIndex()),
        FlBarChart.routeName: (context) => Layout(child: const FlBarChart()),
        CustomChartIndex.routeName: (context) =>
            Layout(child: const CustomChartIndex()),
      },
      home: Layout(child: const Index()),
    );
  }
}
