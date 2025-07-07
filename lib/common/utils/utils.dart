import 'dart:math' as math;

String getDayOfWeek(String date) {
  final dateString = date.contains('.') ? date.replaceAll('.', '-') : date;
  final day = DateTime.parse(dateString).weekday;
  switch (day) {
    case 1:
      return '월';
    case 2:
      return '화';
    case 3:
      return '수';
    case 4:
      return '목';
    case 5:
      return '금';
    case 6:
      return '토';
    case 7:
      return '일';
    default:
      return '';
  }
}

String addComma(dynamic number) {
  // 소수점 버리기
  final intValue = number is String
      ? int.parse(number.split('.')[0])
      : (number is double ? number.toInt() : number);

  return intValue.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
}

// 최대값에 대한 적정 구분 값
double getIntervalValue(double value) {
  return value / 5000;
}

// 최대값을 적절한 단위로 반올림하는 메서드
double roundToNearestUnit(double value) {
  double isMinValue = 10000.0;
  final interval = getIntervalValue(value);
  if (value < 10000) return isMinValue;

  final isIntervalValue = value / interval;
  final ceilLength = ((isIntervalValue).toString().split('.')[0]).length - 2;
  final powValue = math.pow(10, ceilLength);
  final isIntervalMax = (isIntervalValue / powValue).ceil() * powValue;
  final isMaxValue = isIntervalMax * interval;

  // 최소값 보장 (0이 되지 않도록)
  return isMaxValue > isMinValue ? isMaxValue.toDouble() : isMinValue;
}
