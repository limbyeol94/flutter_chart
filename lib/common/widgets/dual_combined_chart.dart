import 'package:flutter/material.dart';
import 'package:flutter_chart/common/widgets/custom_bar_chart.dart';
import 'package:flutter_chart/common/widgets/custom_line_chart.dart';
import 'package:flutter_chart/common/widgets/combined_chart.dart';

class DualCombinedChart extends StatefulWidget {
  final List<ChartData> data1; // 첫 번째 데이터 세트
  final List<ChartData> data2; // 두 번째 데이터 세트
  final double height;
  final Color barColor1;
  final Color barColor2;
  final Color lineColor1;
  final Color lineColor2;
  final bool showGrid;
  final bool showLabels;
  final bool showPoints;

  const DualCombinedChart({
    super.key,
    required this.data1,
    required this.data2,
    this.height = 400,
    this.barColor1 = Colors.blue,
    this.barColor2 = Colors.red,
    this.lineColor1 = Colors.green,
    this.lineColor2 = Colors.orange,
    this.showGrid = true,
    this.showLabels = true,
    this.showPoints = true,
  });

  @override
  State<DualCombinedChart> createState() => _DualCombinedChartState();
}

class _DualCombinedChartState extends State<DualCombinedChart> {
  @override
  Widget build(BuildContext context) {
    // 데이터를 막대 차트와 라인 차트 형식으로 변환
    final barData1 = widget.data1.map((item) {
      return BarData(
        label: item.label,
        value: item.value,
      );
    }).toList();

    final barData2 = widget.data2.map((item) {
      return BarData(
        label: item.label,
        value: item.value,
      );
    }).toList();

    final lineData1 = widget.data1.map((item) {
      return LineData(
        label: item.label,
        value: item.value,
      );
    }).toList();

    final lineData2 = widget.data2.map((item) {
      return LineData(
        label: item.label,
        value: item.value,
      );
    }).toList();

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // 상단: 이중 막대 차트
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Text(
                    '이중 막대 차트',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      children: [
                        // 첫 번째 막대 차트
                        Expanded(
                          child: CustomBarChart(
                            data: barData1,
                            barWidth: 25.0,
                            barSpacing: 10.0,
                            barColor: widget.barColor1,
                            showGrid: widget.showGrid,
                            showLabels: widget.showLabels,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 두 번째 막대 차트
                        Expanded(
                          child: CustomBarChart(
                            data: barData2,
                            barWidth: 25.0,
                            barSpacing: 10.0,
                            barColor: widget.barColor2,
                            showGrid: widget.showGrid,
                            showLabels: widget.showLabels,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // 하단: 이중 라인 차트
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Text(
                    '이중 라인 차트',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      children: [
                        // 첫 번째 라인 차트
                        Expanded(
                          child: CustomLineChart(
                            data: lineData1,
                            lineColor: widget.lineColor1,
                            lineWidth: 2.5,
                            showGrid: widget.showGrid,
                            showLabels: widget.showLabels,
                            showPoints: widget.showPoints,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 두 번째 라인 차트
                        Expanded(
                          child: CustomLineChart(
                            data: lineData2,
                            lineColor: widget.lineColor2,
                            lineWidth: 2.5,
                            showGrid: widget.showGrid,
                            showLabels: widget.showLabels,
                            showPoints: widget.showPoints,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
