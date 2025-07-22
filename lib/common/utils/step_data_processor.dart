import 'dart:developer';

class StepDataProcessor {
  static Map<String, dynamic> processStepData(
      List<Map<String, dynamic>> records) {
    try {
      // 걸음수 데이터만 필터링 (HKQuantityTypeIdentifierStepCount)
      final stepRecords = records
          .where(
              (record) => record['type'] == 'HKQuantityTypeIdentifierStepCount')
          .toList();

      // 날짜별로 그룹화
      final Map<String, List<int>> dailySteps = {};

      for (final record in stepRecords) {
        final startDate = record['startDate'];
        final value = record['value'];

        if (startDate != null) {
          try {
            final date =
                DateTime.parse(startDate).toIso8601String().split('T')[0];

            // value가 null이거나 빈 문자열인 경우 처리
            int steps = 0;
            if (value != null && value.toString().isNotEmpty) {
              steps = int.tryParse(value.toString()) ?? 0;
            }

            dailySteps[date] = [...(dailySteps[date] ?? []), steps];
          } catch (e) {
            print('날짜 파싱 오류: $e, startDate: $startDate');
          }
        }
      }

      // 일별 총 걸음수 계산
      final Map<String, int> dailyTotalSteps = {};
      dailySteps.forEach((date, stepsList) {
        dailyTotalSteps[date] = stepsList.reduce((a, b) => a + b);
      });

      // 평균 계산 (오늘 제외)
      final today = dailyTotalSteps.keys.isNotEmpty
          ? (dailyTotalSteps.keys.toList()..sort()).last
          : DateTime.now().toIso8601String().split('T')[0];
      final previousDays = dailyTotalSteps.entries
          .where((entry) => entry.key != today)
          .map((entry) => entry.value)
          .toList();

      final averageSteps = previousDays.isEmpty
          ? 0
          : previousDays.reduce((a, b) => a + b) / previousDays.length;

      final todaySteps = dailyTotalSteps[today] ?? 0;
      final difference = todaySteps - averageSteps.round();

      return {
        'averageSteps': averageSteps.round(),
        'todaySteps': todaySteps,
        'difference': difference,
        'dailyData': dailyTotalSteps,
        'isAboveAverage': difference > 0,
        'percentageChange': previousDays.isEmpty
            ? 0
            : ((difference / averageSteps) * 100).round(),
      };
    } catch (e) {
      print('걸음수 데이터 처리 오류: $e');
      return {
        'averageSteps': 0,
        'todaySteps': 0,
        'difference': 0,
        'dailyData': {},
        'isAboveAverage': false,
        'percentageChange': 0,
      };
    }
  }

  // 시간대별 걸음수 데이터 처리
  static Map<String, dynamic> processHourlyStepData(
      List<Map<String, dynamic>> records) {
    try {
      // 걸음수 데이터만 필터링
      final stepRecords = records
          .where(
              (record) => record['type'] == 'HKQuantityTypeIdentifierStepCount')
          .toList();

      // 시간대별로 그룹화 (0-23시)
      final Map<int, List<int>> hourlySteps = {};
      for (int i = 0; i < 24; i++) {
        hourlySteps[i] = [];
      }

      // 날짜별 시간대별로 그룹화
      final Map<String, Map<int, List<int>>> dailyHourlySteps = {};

      for (final record in stepRecords) {
        final startDate = record['startDate'];
        final value = record['value'];

        if (startDate != null) {
          try {
            final dateTime = DateTime.parse(startDate);
            final date = dateTime.toIso8601String().split('T')[0];
            final hour = dateTime.hour;

            // value가 null이거나 빈 문자열인 경우 처리
            int steps = 0;
            if (value != null && value.toString().isNotEmpty) {
              steps = int.tryParse(value.toString()) ?? 0;
            }

            // 전체 시간대별 데이터
            hourlySteps[hour] = [...hourlySteps[hour]!, steps];

            // 날짜별 시간대별 데이터
            if (!dailyHourlySteps.containsKey(date)) {
              dailyHourlySteps[date] = {};
              for (int i = 0; i < 24; i++) {
                dailyHourlySteps[date]![i] = [];
              }
            }
            dailyHourlySteps[date]![hour] = [
              ...dailyHourlySteps[date]![hour]!,
              steps
            ];
          } catch (e) {
            print('시간대별 데이터 파싱 오류: $e, startDate: $startDate');
          }
        }
      }

      // 오늘 날짜의 시간대별 데이터
      final today = dailyHourlySteps.keys.isNotEmpty
          ? (dailyHourlySteps.keys.toList()..sort()).last
          : DateTime.now().toIso8601String().split('T')[0];
      final todayHourlyData = dailyHourlySteps[today] ?? {};

      // 오늘 시간대별 총 걸음수
      final Map<int, int> todayHourlyTotalSteps = {};
      todayHourlyData.forEach((hour, stepsList) {
        if (stepsList.isNotEmpty) {
          todayHourlyTotalSteps[hour] = stepsList.reduce((a, b) => a + b);
        } else {
          todayHourlyTotalSteps[hour] = 0;
        }
      });

      // 시간대별 평균 걸음수 계산 (오늘 제외)
      final Map<int, int> hourlyAverageSteps = {};
      for (int hour = 0; hour < 24; hour++) {
        final List<int> allStepsForHour = [];

        // 오늘을 제외한 모든 날짜의 해당 시간대 데이터 수집
        dailyHourlySteps.forEach((date, hourlyData) {
          if (date != today && hourlyData[hour] != null) {
            allStepsForHour.addAll(hourlyData[hour]!);
          }
        });

        if (allStepsForHour.isNotEmpty) {
          hourlyAverageSteps[hour] =
              (allStepsForHour.reduce((a, b) => a + b) / allStepsForHour.length)
                  .round();
        } else {
          hourlyAverageSteps[hour] = 0;
        }
      }

      return {
        'hourlyAverageSteps': hourlyAverageSteps,
        'todayHourlySteps': todayHourlyTotalSteps,
        'dailyHourlySteps': dailyHourlySteps,
        'todayDate': today,
      };
    } catch (e) {
      print('시간대별 걸음수 데이터 처리 오류: $e');
      return {
        'hourlyAverageSteps': {},
        'todayHourlySteps': {},
        'dailyHourlySteps': {},
        'todayDate': DateTime.now().toIso8601String().split('T')[0],
      };
    }
  }

  // 시간대별 차트용 데이터 포맷
  static List<Map<String, dynamic>> formatHourlyChartData(
      Map<int, int> hourlyData) {
    final List<Map<String, dynamic>> chartData = [];

    for (int hour = 0; hour < 24; hour++) {
      chartData.add({
        'hour': hour,
        'steps': hourlyData[hour] ?? 0,
        'timeLabel': '${hour.toString().padLeft(2, '0')}:00',
      });
    }

    return chartData;
  }

  // 최근 7일 데이터만 반환
  static Map<String, int> getRecentWeekData(Map<String, int> dailyData) {
    final sortedDates = dailyData.keys.toList()..sort();
    final recentDates = sortedDates.take(7).toList();

    final Map<String, int> recentData = {};
    for (final date in recentDates) {
      recentData[date] = dailyData[date] ?? 0;
    }

    return recentData;
  }

  // 라인 차트용 데이터 포맷
  static List<Map<String, dynamic>> formatForLineChart(
      Map<String, int> dailyData) {
    final sortedEntries = dailyData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sortedEntries.asMap().entries.map((entry) {
      return {
        'index': entry.key,
        'date': entry.value.key,
        'steps': entry.value.value,
      };
    }).toList();
  }
}
