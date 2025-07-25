import 'package:flutter/material.dart';
import 'package:flutter_chart/common/utils/step_data_processor.dart';
import 'package:flutter_chart/common/widgets/custom_bar_chart.dart';
import 'package:flutter_chart/common/widgets/custom_line_chart.dart';
import 'package:flutter_chart/common/widgets/combined_chart.dart';
import 'package:flutter_chart/common/widgets/dual_combined_chart.dart';
import 'package:flutter_chart/common/widgets/unified_chart.dart';
import 'package:flutter_chart/common/widgets/chart_coordinate_guide.dart';

class CustomChartContent extends StatefulWidget {
  const CustomChartContent({super.key});

  @override
  State<CustomChartContent> createState() => _CustomChartContentState();
}

class _CustomChartContentState extends State<CustomChartContent> {
  List<BarData> barChartData = [];
  List<LineData> lineChartData1 = [];
  List<LineData> lineChartData2 = [];
  List<ChartData> combinedChartData = [];
  List<ChartData> combinedChartData2 = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTestData();
  }

  Future<void> _loadTestData() async {
    // 테스트 데이터 생성 - 첫 번째 데이터 세트
    final List<Map<String, dynamic>> testStepRecords1 = [
      {'type': 'HKQuantityTypeIdentifierStepCount', 'startDate': '2024-06-07T10:00:00+0900', 'value': '1200'},
      {'type': 'HKQuantityTypeIdentifierStepCount', 'startDate': '2024-06-08T10:00:00+0900', 'value': '1500'},
      {'type': 'HKQuantityTypeIdentifierStepCount', 'startDate': '2024-06-09T10:00:00+0900', 'value': '900'},
      {'type': 'HKQuantityTypeIdentifierStepCount', 'startDate': '2024-06-10T10:00:00+0900', 'value': '2000'},
      {'type': 'HKQuantityTypeIdentifierStepCount', 'startDate': '2024-06-11T10:00:00+0900', 'value': '800'},
      {'type': 'HKQuantityTypeIdentifierStepCount', 'startDate': '2024-06-12T10:00:00+0900', 'value': '1700'},
      {'type': 'HKQuantityTypeIdentifierStepCount', 'startDate': '2024-06-13T10:00:00+0900', 'value': '1800'},
    ];

    // 두 번째 데이터 세트 (다른 패턴)
    final List<Map<String, dynamic>> testStepRecords2 = [
      {'type': 'HKQuantityTypeIdentifierStepCount', 'startDate': '2024-06-07T10:00:00+0900', 'value': '800'},
      {'type': 'HKQuantityTypeIdentifierStepCount', 'startDate': '2024-06-08T10:00:00+0900', 'value': '2200'},
      {'type': 'HKQuantityTypeIdentifierStepCount', 'startDate': '2024-06-09T10:00:00+0900', 'value': '1100'},
      {'type': 'HKQuantityTypeIdentifierStepCount', 'startDate': '2024-06-10T10:00:00+0900', 'value': '1600'},
      {'type': 'HKQuantityTypeIdentifierStepCount', 'startDate': '2024-06-11T10:00:00+0900', 'value': '1300'},
      {'type': 'HKQuantityTypeIdentifierStepCount', 'startDate': '2024-06-12T10:00:00+0900', 'value': '1900'},
      {'type': 'HKQuantityTypeIdentifierStepCount', 'startDate': '2024-06-13T10:00:00+0900', 'value': '1400'},
    ];

    // 데이터 가공 - 첫 번째 데이터 세트
    final data1 = StepDataProcessor.processStepData(testStepRecords1);
    final dailyData1 = Map<String, int>.from(data1['dailyData'] ?? {});

    // 두 번째 데이터 세트
    final data2 = StepDataProcessor.processStepData(testStepRecords2);
    final dailyData2 = Map<String, int>.from(data2['dailyData'] ?? {});

    // 막대 차트 데이터 변환 (첫 번째 데이터 사용)
    final sortedEntries1 = dailyData1.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    barChartData = sortedEntries1.map((entry) {
      return BarData(
        label: entry.key.substring(5), // MM-DD 형식
        value: entry.value.toDouble(),
      );
    }).toList();

    // 첫 번째 라인 차트 데이터 변환
    lineChartData1 = sortedEntries1.map((entry) {
      return LineData(
        label: entry.key.substring(5), // MM-DD 형식
        value: entry.value.toDouble(),
      );
    }).toList();

    // 두 번째 라인 차트 데이터 변환
    final sortedEntries2 = dailyData2.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    lineChartData2 = sortedEntries2.map((entry) {
      return LineData(
        label: entry.key.substring(5), // MM-DD 형식
        value: entry.value.toDouble(),
      );
    }).toList();

    // 통합 차트 데이터 설정 (첫 번째 데이터 사용)
    combinedChartData = sortedEntries1.map((entry) {
      return ChartData(
        label: entry.key.substring(5), // MM-DD 형식
        value: entry.value.toDouble(),
      );
    }).toList();

    // 두 번째 통합 차트 데이터 설정
    combinedChartData2 = sortedEntries2.map((entry) {
      return ChartData(
        label: entry.key.substring(5), // MM-DD 형식
        value: entry.value.toDouble(),
      );
    }).toList();

    setState(() {
      isLoading = false;
    });

    print('커스텀 차트 데이터 로드 완료:');
    print('막대 차트 데이터: $barChartData');
    print('첫 번째 라인 차트 데이터: $lineChartData1');
    print('두 번째 라인 차트 데이터: $lineChartData2');
    print('통합 차트 데이터: $combinedChartData');
    print('두 번째 통합 차트 데이터: $combinedChartData2');
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 막대 차트
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '커스텀 막대 차트',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300,
                          child: CustomBarChart(
                            data: barChartData,
                            barWidth: 35.0,
                            barSpacing: 20.0,
                            barColor: Colors.blue,
                            showGrid: true,
                            showLabels: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 라인 차트
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '커스텀 라인 차트',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300,
                          child: CustomLineChart(
                            data: lineChartData1,
                            lineColor: Colors.green,
                            lineWidth: 3.0,
                            showGrid: true,
                            showLabels: true,
                            showPoints: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 통합 차트 (라인 + 막대)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '통합 차트 (라인 + 막대)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '하나의 그래프 안에서 같은 데이터를 막대와 라인으로 동시에 표시',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 400,
                          child: UnifiedChart(
                            barData: combinedChartData,
                            lineData: combinedChartData2,
                            barColor: Colors.blue,
                            lineColor: Colors.green,
                            showGrid: true,
                            showLabels: true,
                            showPoints: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 좌표 계산 및 그리기 가이드
                // const ChartCoordinateGuide(),
              ],
            ),
          );
  }
}

class CustomChartScreen extends StatefulWidget {
  const CustomChartScreen({super.key});
  static const String routeName = '/custom_chart_screen';

  @override
  State<CustomChartScreen> createState() => _CustomChartScreenState();
}

class _CustomChartScreenState extends State<CustomChartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커스텀 차트'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: const CustomChartContent(),
    );
  }
}
