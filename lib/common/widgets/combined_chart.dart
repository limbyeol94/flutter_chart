import 'package:flutter/material.dart';
import 'package:flutter_chart/common/widgets/custom_bar_chart.dart';
import 'package:flutter_chart/common/widgets/custom_line_chart.dart';

class CombinedChart extends StatefulWidget {
  final List<ChartData> data;
  final double height;
  final Color barColor;
  final Color lineColor;
  final bool showGrid;
  final bool showLabels;
  final bool showPoints;

  const CombinedChart({
    super.key,
    required this.data,
    this.height = 300,
    this.barColor = Colors.blue,
    this.lineColor = Colors.green,
    this.showGrid = true,
    this.showLabels = true,
    this.showPoints = true,
  });

  @override
  State<CombinedChart> createState() => _CombinedChartState();
}

class _CombinedChartState extends State<CombinedChart> {
  @override
  Widget build(BuildContext context) {
    // 데이터를 막대 차트와 라인 차트 형식으로 변환
    final barData = widget.data.map((item) {
      return BarData(
        label: item.label,
        value: item.value,
      );
    }).toList();

    final lineData = widget.data.map((item) {
      return LineData(
        label: item.label,
        value: item.value,
      );
    }).toList();

    return Column(
      children: [
        // 막대 차트
        Container(
          height: widget.height / 2,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomBarChart(
            data: barData,
            barWidth: 30.0,
            barSpacing: 15.0,
            barColor: widget.barColor,
            showGrid: widget.showGrid,
            showLabels: widget.showLabels,
          ),
        ),
        const SizedBox(height: 16),
        // 라인 차트
        Container(
          height: widget.height / 2,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomLineChart(
            data: lineData,
            lineColor: widget.lineColor,
            lineWidth: 3.0,
            showGrid: widget.showGrid,
            showLabels: widget.showLabels,
            showPoints: widget.showPoints,
          ),
        ),
      ],
    );
  }
}

// 통합 데이터 모델
class ChartData {
  final String label;
  final double value;

  ChartData({
    required this.label,
    required this.value,
  });
}
