import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chart/common/data/models/healthy_step_model.dart';
import 'package:flutter_chart/common/widgets/fl_healthy_bar_chart.dart';

class FlBarChart extends StatefulWidget {
  const FlBarChart({super.key});
  static const String routeName = '/fl_bar_chart';

  @override
  State<FlBarChart> createState() => _FlBarChartState();
}

class _FlBarChartState extends State<FlBarChart> {
  List<HealthyStepModel> myData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/test_data.js');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    setState(() {
      myData = jsonData.map((e) => HealthyStepModel.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return myData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '평균',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '걸음',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${myData.first.date} ~ ${myData.last.date}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: FlHealthyBarChart(data: myData)),
              ],
            ),
          );
  }
}
