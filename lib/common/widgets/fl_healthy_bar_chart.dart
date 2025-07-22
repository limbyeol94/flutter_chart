import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart/common/data/models/healthy_step_model.dart';
import 'package:flutter_chart/common/utils/utils.dart';

class FlHealthyBarChart extends StatelessWidget {
  const FlHealthyBarChart({super.key, required this.data});
  final List<HealthyStepModel> data;

  @override
  Widget build(BuildContext context) {
    // 데이터의 최대값 계산
    final maxValue = data.fold<double>(
        0,
        (max, item) =>
            double.parse(item.step) > max ? double.parse(item.step) : max);

    // 최대값을 적절한 단위로 반올림 (예: 13249 -> 15000)
    final isMaxValue = roundToNearestUnit(maxValue);

    return BarChart(
      BarChartData(
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey, width: 0.5),
          // border: const Border(
          //   top: BorderSide(color: Colors.grey, width: 0.5),
          //   bottom: BorderSide(color: Colors.grey, width: 0.5),
          // ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: isMaxValue / getIntervalValue(isMaxValue),
          verticalInterval: data.length.toDouble(),
        ),
        maxY: isMaxValue, // Y축 최대값 설정
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black87,
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            tooltipMargin: 8,
            maxContentWidth: 200,
            fitInsideHorizontally: true, // 가로 방향으로 차트 안에 맞춤
            fitInsideVertically: false, // 세로 방향으로 차트 안에 맞춤
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '총\n',
                textAlign: TextAlign.left,
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: addComma(rod.toY - 1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(
                    text: ' 걸음\n',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '${data[group.x].date}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval:
                  isMaxValue / getIntervalValue(isMaxValue), // 동적으로 계산된 간격 사용
              getTitlesWidget: (value, meta) {
                // log('value: $value');
                return Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    addComma(value.toInt()),
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
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  final title = getDayOfWeek(data[index].date);
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
                    toY: double.parse(entry.value.step),
                    width: 30,
                    borderRadius: const BorderRadius.only(
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
    );
  }
}
