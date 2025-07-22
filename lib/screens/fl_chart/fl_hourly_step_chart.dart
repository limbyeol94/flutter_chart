import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter_chart/common/utils/step_data_processor.dart';
import 'package:flutter_chart/common/utils/utils.dart';

class FlHourlyStepChart extends StatefulWidget {
  const FlHourlyStepChart({super.key});
  static const String routeName = '/fl_hourly_step_chart';

  @override
  State<FlHourlyStepChart> createState() => _FlHourlyStepChartState();
}

class _FlHourlyStepChartState extends State<FlHourlyStepChart> {
  Map<String, dynamic> hourlyData = {};
  List<Map<String, dynamic>> averageChartData = [];
  List<Map<String, dynamic>> todayChartData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHourlyData();
  }

  Future<void> _loadHourlyData() async {
    try {
      // 테스트 데이터 생성 - 시간대별로 분산된 데이터
      final List<Map<String, dynamic>> testStepRecords = [
        // 2024-06-07 (과거 데이터)
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-07T06:00:00+0900',
          'value': '200'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-07T08:00:00+0900',
          'value': '500'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-07T12:00:00+0900',
          'value': '300'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-07T18:00:00+0900',
          'value': '200'
        },

        // 2024-06-08 (과거 데이터)
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-08T07:00:00+0900',
          'value': '300'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-08T09:00:00+0900',
          'value': '600'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-08T13:00:00+0900',
          'value': '400'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-08T19:00:00+0900',
          'value': '200'
        },

        // 2024-06-09 (과거 데이터)
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-09T06:00:00+0900',
          'value': '150'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-09T10:00:00+0900',
          'value': '400'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-09T14:00:00+0900',
          'value': '250'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-09T20:00:00+0900',
          'value': '100'
        },

        // 2024-06-10 (과거 데이터)
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-10T05:00:00+0900',
          'value': '100'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-10T08:00:00+0900',
          'value': '800'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-10T12:00:00+0900',
          'value': '600'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-10T16:00:00+0900',
          'value': '300'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-10T20:00:00+0900',
          'value': '200'
        },

        // 2024-06-11 (과거 데이터)
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-11T07:00:00+0900',
          'value': '200'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-11T11:00:00+0900',
          'value': '300'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-11T15:00:00+0900',
          'value': '200'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-11T21:00:00+0900',
          'value': '100'
        },

        // 2024-06-12 (과거 데이터)
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-12T06:00:00+0900',
          'value': '250'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-12T09:00:00+0900',
          'value': '700'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-12T13:00:00+0900',
          'value': '500'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-12T17:00:00+0900',
          'value': '200'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-12T22:00:00+0900',
          'value': '50'
        },

        // 2024-06-13 (오늘 데이터)
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-13T05:00:00+0900',
          'value': '100'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-13T07:00:00+0900',
          'value': '400'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-13T09:00:00+0900',
          'value': '800'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-13T11:00:00+0900',
          'value': '300'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-13T13:00:00+0900',
          'value': '200'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-13T15:00:00+0900',
          'value': '400'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-13T17:00:00+0900',
          'value': '300'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-13T19:00:00+0900',
          'value': '200'
        },
        {
          'type': 'HKQuantityTypeIdentifierStepCount',
          'startDate': '2024-06-13T21:00:00+0900',
          'value': '100'
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('시간대별 걸음수'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 요약 정보
                  _buildSummaryCard(),
                  const SizedBox(height: 20),

                  // 시간대별 통합 라인 차트
                  _buildHourlyChart('시간대별 걸음수 비교'),
                  const SizedBox(height: 20),

                  // 시간대별 상세 데이터
                  _buildHourlyDataList(),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard() {
    final todayDate = hourlyData['todayDate'] ?? '';
    final totalTodaySteps = todayChartData.fold<int>(
        0, (sum, item) => sum + (item['steps'] as int));
    final totalAverageSteps = averageChartData.fold<int>(
        0, (sum, item) => sum + (item['steps'] as int));
    final difference = totalTodaySteps - totalAverageSteps;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '시간대별 걸음수 요약',
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
                    '오늘 총 걸음수',
                    '${addComma(totalTodaySteps)}',
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    '평균 총 걸음수',
                    '${addComma(totalAverageSteps)}',
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
                    '가장 활발한 시간',
                    _getMostActiveHour(),
                    Colors.orange,
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

  String _getMostActiveHour() {
    if (todayChartData.isEmpty) return 'N/A';

    final mostActive = todayChartData
        .reduce((a, b) => (a['steps'] as int) > (b['steps'] as int) ? a : b);

    return '${mostActive['timeLabel']}';
  }

  Widget _buildHourlyChart(String title) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
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
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 3, // 3시간마다 표시
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < 24 && index % 3 == 0) {
                            final timeLabel =
                                '${index.toString().padLeft(2, '0')}:00';
                            return Text(
                              timeLabel,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        interval: 100,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 100,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  lineBarsData: [
                    // 평균 데이터 라인
                    LineChartBarData(
                      spots: _getAverageSpots(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.blue,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                    // 오늘 데이터 라인
                    LineChartBarData(
                      spots: _getTodaySpots(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
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
                        return touchedSpots.map((touchedSpot) {
                          final hour = touchedSpot.x.toInt();
                          final timeLabel =
                              '${hour.toString().padLeft(2, '0')}:00';
                          final averageSteps = _getAverageStepsAtHour(hour);
                          final todaySteps = _getTodayStepsAtHour(hour);

                          return LineTooltipItem(
                            '$timeLabel\n',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '평균: ${addComma(averageSteps)} 걸음\n',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: '오늘: ${addComma(todaySteps)} 걸음',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          );
                        }).toList();
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
                      '오늘',
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
    double maxAverage = averageChartData.fold<double>(
      0,
      (max, item) => (item['steps'] as int) > max
          ? (item['steps'] as int).toDouble()
          : max,
    );

    double maxToday = todayChartData.fold<double>(
      0,
      (max, item) => (item['steps'] as int) > max
          ? (item['steps'] as int).toDouble()
          : max,
    );

    return maxAverage > maxToday ? maxAverage : maxToday;
  }

  List<FlSpot> _getAverageSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < 24; i++) {
      final steps = _getAverageStepsAtHour(i);
      spots.add(FlSpot(i.toDouble(), steps.toDouble()));
    }
    return spots;
  }

  List<FlSpot> _getTodaySpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < 24; i++) {
      final steps = _getTodayStepsAtHour(i);
      spots.add(FlSpot(i.toDouble(), steps.toDouble()));
    }
    return spots;
  }

  int _getAverageStepsAtHour(int hour) {
    if (averageChartData.isEmpty || hour >= averageChartData.length) {
      return 0;
    }
    return averageChartData[hour]['steps'] as int;
  }

  int _getTodayStepsAtHour(int hour) {
    if (todayChartData.isEmpty || hour >= todayChartData.length) {
      return 0;
    }
    return todayChartData[hour]['steps'] as int;
  }

  Widget _buildHourlyDataList() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '시간대별 상세 데이터',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(24, (index) {
              final hour = index;
              final todaySteps = todayChartData.isNotEmpty
                  ? todayChartData[index]['steps'] as int
                  : 0;
              final averageSteps = averageChartData.isNotEmpty
                  ? averageChartData[index]['steps'] as int
                  : 0;
              final timeLabel = '${hour.toString().padLeft(2, '0')}:00';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        timeLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '오늘: ${addComma(todaySteps)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '평균: ${addComma(averageSteps)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
