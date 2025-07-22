import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chart/common/data/models/healthy_step_model.dart';

import 'package:flutter_chart/common/utils/step_data_processor.dart';
import 'package:flutter_chart/common/widgets/fl_healthy_line_chart.dart';

class FlLineChart extends StatefulWidget {
  const FlLineChart({super.key});
  static const String routeName = '/fl_line_chart';

  @override
  State<FlLineChart> createState() => _FlLineChartState();
}

class _FlLineChartState extends State<FlLineChart> {
  Map<String, dynamic> hourlyData = {};
  List<Map<String, dynamic>> averageChartData = [];
  List<Map<String, dynamic>> todayChartData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // 테스트 데이터 생성
      final List<Map<String, dynamic>> testStepRecords = [
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-07T10:00:00+0900',
          'value': '1200'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-08T10:00:00+0900',
          'value': '1500'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-09T10:00:00+0900',
          'value': '900'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-10T10:00:00+0900',
          'value': '2000'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-11T10:00:00+0900',
          'value': '800'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-12T10:00:00+0900',
          'value': '1700'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-13T10:00:00+0900',
          'value': '1800'
        },
      ];

      // 시간대별 데이터 처리
      final data = StepDataProcessor.processHourlyStepData(testStepRecords);

      setState(() {
        hourlyData = data;
        averageChartData = StepDataProcessor.formatHourlyChartData(
            Map<int, int>.from(data['hourlyAverageSteps'] ?? {}));
        todayChartData = StepDataProcessor.formatHourlyChartData(
            Map<int, int>.from(data['todayHourlySteps'] ?? {}));
        isLoading = false;
      });

      print('시간대별 데이터 로드 완료');
      print('평균 데이터: $averageChartData');
      print('오늘 데이터: $todayChartData');
    } catch (e) {
      print('시간대별 데이터 로드 오류: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
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
                      // Text(
                      //   '${hourlyData.first.date} ~ ${hourlyData.last.date}',
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Expanded(child: FlHealthyLineChart()),
              ],
            ),
          );
    ;
  }
}
