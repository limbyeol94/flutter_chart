import 'package:flutter/material.dart';
import 'package:flutter_chart/screens/fl_chart/fl_bar_chart.dart';
import 'package:flutter_chart/screens/fl_chart/fl_line_chart.dart';
import 'package:flutter_chart/screens/fl_chart/fl_health_line_chart.dart';
import 'package:flutter_chart/screens/fl_chart/fl_hourly_step_chart.dart';

class FlChartIndex extends StatelessWidget {
  const FlChartIndex({super.key});

  static const String routeName = '/fl_chart_index';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Builder(builder: (context) {
        final height = MediaQuery.of(context).size.height;
        return Column(
          children: [
            // SizedBox(height: height, child: FlBarChart()),
            const SizedBox(height: 20),
            SizedBox(height: height, child: FlHealthLineChart()),
            // SizedBox(height: height, child: FlHourlyStepChart()),
            // SizedBox(height: height, child: FlLineChart()),
            // _buildHealthDataSection(context),
            // const SizedBox(height: 20),
            // _buildHourlyDataSection(context),
          ],
        );
      }),
    );
  }

  Widget _buildHealthDataSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, FlHealthLineChart.routeName),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.1),
                  Colors.purple.withOpacity(0.05)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.purple,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Health Data Line Chart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '아이폰 건강 데이터 라인 차트',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.purple,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildHourlyDataSection(BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(16),
    child: Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, FlHourlyStepChart.routeName),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                Colors.orange.withOpacity(0.1),
                Colors.orange.withOpacity(0.05)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                color: Colors.orange,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hourly Step Chart',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '시간대별 걸음수 차트',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.orange,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
