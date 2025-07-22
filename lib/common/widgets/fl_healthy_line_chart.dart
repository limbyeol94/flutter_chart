import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FlHealthyLineChart extends StatelessWidget {
  const FlHealthyLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    // 오늘 걸음수, 평균 걸음 수
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // log('value: $value');
                return Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.left,
                  ),
                );
              },
            ),
          ),
        ),
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
          LineChartBarData(spots: [
            FlSpot(0, 1),
            FlSpot(1, 2),
            FlSpot(2, 3),
            FlSpot(3, 4),
            FlSpot(4, 5),
            FlSpot(5, 6),
            FlSpot(6, 4),
            FlSpot(7, 4.5),
            FlSpot(8, 5),
          ]),
        ],
      ),
    );
  }
}
