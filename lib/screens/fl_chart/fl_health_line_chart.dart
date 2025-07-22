import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_chart/common/utils/step_data_processor.dart';
import 'package:flutter_chart/common/utils/utils.dart';

class FlHealthLineChart extends StatefulWidget {
  const FlHealthLineChart({super.key});
  static const String routeName = '/fl_health_line_chart';

  @override
  State<FlHealthLineChart> createState() => _FlHealthLineChartState();
}

class _FlHealthLineChartState extends State<FlHealthLineChart> {
  Map<String, dynamic> stepData = {};
  List<Map<String, dynamic>> actualChartData = [];
  List<Map<String, dynamic>> averageChartData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTestData();
  }

  Future<void> _loadTestData() async {
    // 7일치 테스트 걸음수 데이터 (오늘 포함)
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
      }, // 오늘
    ];

    // 데이터 가공
    final data = StepDataProcessor.processStepData(testStepRecords);
    print('StepDataProcessor 결과: $data');

    final dailyData = Map<String, int>.from(data['dailyData'] ?? {});
    print('dailyData: $dailyData');

    final actualChartData = StepDataProcessor.formatForLineChart(dailyData);
    print('formatForLineChart 결과: $actualChartData');

    // 평균 데이터 생성 (들락날락하는 패턴으로 조정)
    final averageSteps = data['averageSteps'] ?? 0;
    print('평균 걸음수: $averageSteps');

    // 평균값을 기반으로 들락날락하는 패턴 생성
    final List<int> averagePattern = [
      (averageSteps * 0.8).round(), // 첫째날: 평균의 80%
      (averageSteps * 1.1).round(), // 둘째날: 평균의 110%
      (averageSteps * 0.9).round(), // 셋째날: 평균의 90%
      (averageSteps * 1.2).round(), // 넷째날: 평균의 120%
      (averageSteps * 0.7).round(), // 다섯째날: 평균의 70%
      (averageSteps * 1.0).round(), // 여섯째날: 평균의 100%
      (averageSteps * 0.95).round(), // 일곱째날: 평균의 95%
    ];

    final averageChartData = actualChartData.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final patternIndex = index < averagePattern.length ? index : 0;

      return {
        'index': item['index'],
        'date': item['date'],
        'steps': averagePattern[patternIndex],
      };
    }).toList();

    setState(() {
      stepData = data;
      this.actualChartData = actualChartData;
      this.averageChartData = averageChartData;
      isLoading = false;
    });

    // 디버깅을 위한 출력
    print('데이터 로딩 완료:');
    print('stepData: $stepData');
    print('actualChartData: $actualChartData');
    print('averageChartData: $averageChartData');
    print('actualChartData 길이: ${actualChartData.length}');
    print('averageChartData 길이: ${averageChartData.length}');
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(),
              const SizedBox(height: 20),
              _buildLineChart(),
            ],
          );
  }

  Widget _buildSummaryCard() {
    final todaySteps = stepData['todaySteps'] ?? 0;
    final averageSteps = stepData['averageSteps'] ?? 0;
    final difference = stepData['difference'] ?? 0;
    final isAboveAverage = stepData['isAboveAverage'] ?? false;
    final percentageChange = stepData['percentageChange'] ?? 0;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '걸음수 요약',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    '오늘 걸음수',
                    '${addComma(todaySteps)}',
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    '평균 걸음수',
                    '${addComma(averageSteps)}',
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    '차이',
                    '${difference >= 0 ? '+' : ''}${addComma(difference)}',
                    difference >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    '평균 대비',
                    '$percentageChange%',
                    isAboveAverage ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    print('_buildLineChart 호출됨');
    print('actualChartData 길이: ${actualChartData.length}');
    print('averageChartData 길이: ${averageChartData.length}');

    if (actualChartData.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('차트 데이터가 없습니다.'),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '최근 7일 걸음수 추이',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: _getMaxY() * 1.2,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 400,
                        getTitlesWidget: (value, meta) => Text(
                            '${value.toInt()}',
                            style: const TextStyle(fontSize: 10)),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx >= 0 && idx < actualChartData.length) {
                            final date = actualChartData[idx]['date'] as String;
                            return Text(date.substring(5),
                                style: const TextStyle(fontSize: 10));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: true, horizontalInterval: 400),
                  borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.withOpacity(0.3))),
                  lineBarsData: [
                    // 평균 데이터 라인
                    LineChartBarData(
                      spots: averageChartData
                          .map((e) => FlSpot((e['index'] as int).toDouble(),
                              (e['steps'] as int).toDouble()))
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: Colors.blue,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                    // 실제 데이터 라인
                    LineChartBarData(
                      spots: actualChartData
                          .map((e) => FlSpot((e['index'] as int).toDouble(),
                              (e['steps'] as int).toDouble()))
                          .toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: Colors.green,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.black87,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      tooltipMargin: 8,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots
                            .map((touchedSpot) {
                              final index = touchedSpot.x.toInt();
                              if (index >= 0 &&
                                  index < actualChartData.length) {
                                final date =
                                    actualChartData[index]['date'] as String;
                                final actualSteps =
                                    actualChartData[index]['steps'] as int;
                                final averageSteps =
                                    averageChartData[index]['steps'] as int;

                                return LineTooltipItem(
                                  '${date.substring(5)}\n',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '실제: ${addComma(actualSteps)} 걸음\n',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '평균: ${addComma(averageSteps)} 걸음',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return null;
                            })
                            .where((item) => item != null)
                            .toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 범례 추가
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 3,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '평균',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 3,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '실제',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _getMaxY() {
    double maxActual = actualChartData.fold<double>(
      0,
      (max, item) => (item['steps'] as int) > max
          ? (item['steps'] as int).toDouble()
          : max,
    );

    double maxAverage = averageChartData.fold<double>(
      0,
      (max, item) => (item['steps'] as int) > max
          ? (item['steps'] as int).toDouble()
          : max,
    );

    return maxActual > maxAverage ? maxActual : maxAverage;
  }
}
