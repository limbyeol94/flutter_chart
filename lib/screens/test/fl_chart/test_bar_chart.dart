import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum key { title, xTitle, value }

class TestBarChart extends StatelessWidget {
  const TestBarChart({super.key});
  static const String routeName = '/test_bar';

  @override
  Widget build(BuildContext context) {
    final List<Map<key, dynamic>> data = [
      {
        key.title: '2025.06.30',
        key.xTitle: '월',
        key.value: 7770,
      },
      {
        key.title: '2025.07.01',
        key.xTitle: '화',
        key.value: 3450,
      },
      {
        key.title: '2025.07.02',
        key.xTitle: '수',
        key.value: 1520,
      },
      {
        key.title: '2025.07.03',
        key.xTitle: '목',
        key.value: 5194,
      },
      {
        key.title: '2025.07.04',
        key.xTitle: '금',
        key.value: 5971,
      },
      {
        key.title: '2025.07.05',
        key.xTitle: '토',
        key.value: 2781,
      },
      {
        key.title: '2025.07.06',
        key.xTitle: '일',
        key.value: 1767,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String weekDay;
                switch (group.x) {
                  case 0:
                    weekDay = 'Monday';
                    break;
                  case 1:
                    weekDay = 'Tuesday';
                    break;
                  case 2:
                    weekDay = 'Wednesday';
                    break;
                  case 3:
                    weekDay = 'Thursday';
                    break;
                  case 4:
                    weekDay = 'Friday';
                    break;
                  case 5:
                    weekDay = 'Saturday';
                    break;
                  case 6:
                    weekDay = 'Sunday';
                    break;
                  default:
                    throw Error();
                }
                return BarTooltipItem(
                  '${data[group.x][key.title]}\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: (rod.toY - 1).toString(),
                      style: const TextStyle(
                        color: Colors.white, //widget.touchedBarColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    final title = data[index][key.xTitle]?.toString() ?? '';
                    return Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          barGroups: data
              .asMap()
              .entries
              .map(
                (entry) => BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value[key.value].toDouble(),
                      width: 30,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.zero,
                      ),
                      color: Colors.blue,
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
