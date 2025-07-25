import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomLineChart extends StatefulWidget {
  final List<LineData> data;
  final Color lineColor;
  final Color backgroundColor;
  final double lineWidth;
  final bool showGrid;
  final bool showLabels;
  final bool showPoints;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const CustomLineChart({
    super.key,
    required this.data,
    this.lineColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.lineWidth = 3.0,
    this.showGrid = true,
    this.showLabels = true,
    this.showPoints = true,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _LineChartPainter(
            data: widget.data,
            lineColor: widget.lineColor,
            backgroundColor: widget.backgroundColor,
            lineWidth: widget.lineWidth,
            showGrid: widget.showGrid,
            showLabels: widget.showLabels,
            showPoints: widget.showPoints,
            labelStyle: widget.labelStyle,
            valueStyle: widget.valueStyle,
          ),
        );
      },
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<LineData> data;
  final Color lineColor;
  final Color backgroundColor;
  final double lineWidth;
  final bool showGrid;
  final bool showLabels;
  final bool showPoints;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  _LineChartPainter({
    required this.data,
    required this.lineColor,
    required this.backgroundColor,
    required this.lineWidth,
    required this.showGrid,
    required this.showLabels,
    required this.showPoints,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // 1. 좌표 계산 가이드
    // _calculateCoordinates(size);

    print('=== 라인 차트 좌표 계산 가이드 ===');
    print('캔버스 크기: ${size.width} x ${size.height}');
    print('데이터 개수: ${data.length}');

    // 최대값과 최소값 찾기
    final maxValue = data.map((d) => d.value).reduce(math.max);
    final minValue = data.map((d) => d.value).reduce(math.min);
    print('최대값: $maxValue, 최소값: $minValue');

    // 여백 계산
    const padding = 40.0;
    const labelHeight = 30.0;
    const valueHeight = 20.0;

    // 차트 영역 계산
    final chartWidth = size.width - (padding * 2);
    final chartHeight = size.height - (padding * 2) - labelHeight - valueHeight;

    print('차트 영역: $chartWidth x $chartHeight');

    // X축 스케일 계산
    final xScale = chartWidth / (data.length - 1);
    print('X축 스케일: $xScale (1단위당 픽셀)');

    // Y축 스케일 계산
    final valueRange = maxValue - minValue;
    final yScale = chartHeight / valueRange;
    print('Y축 스케일: $yScale (1단위당 픽셀)');

    // 각 포인트의 좌표 계산
    // for (int i = 0; i < data.length; i++) {
    //   final pointData = data[i];
    //   final x = padding + (i * xScale);
    //   final y = size.height - padding - labelHeight - ((pointData.value - minValue) * yScale);

    //   print('포인트 ${i + 1} (${pointData.label}):');
    //   print('  - X: $x');
    //   print('  - Y: $y');
    //   print('  - 값: ${pointData.value}');
    // }
    // _calculateValueMap(
    Map<String, double> valueMap = {
      'maxValue': maxValue,
      'minValue': minValue,
      'padding': padding,
      'labelHeight': labelHeight,
      'valueHeight': valueHeight,
      'chartWidth': chartWidth,
      'chartHeight': chartHeight,
      'xScale': xScale,
      'yScale': yScale,
      'valueRange': valueRange,
    };
    // );

    print('================================');

    // 2. 배경 그리기
    _drawBackground(canvas, size, valueMap);

    // 3. 격자 그리기
    if (showGrid) {
      _drawGrid(canvas, size, valueMap);
    }

    // 4. 라인 그리기
    _drawLine(canvas, size, valueMap);

    // 5. 포인트 그리기
    if (showPoints) {
      _drawPoints(canvas, size, valueMap);
    }

    // 6. 라벨 그리기
    if (showLabels) {
      _drawLabels(canvas, size, valueMap);
    }
  }

  // 좌표 계산 가이드
  void _calculateCoordinates(Size size) {
    print('=== 라인 차트 좌표 계산 가이드 ===');
    print('캔버스 크기: ${size.width} x ${size.height}');
    print('데이터 개수: ${data.length}');

    // 최대값과 최소값 찾기
    final maxValue = data.map((d) => d.value).reduce(math.max);
    final minValue = data.map((d) => d.value).reduce(math.min);
    print('최대값: $maxValue, 최소값: $minValue');

    // 여백 계산
    const padding = 40.0;
    const labelHeight = 30.0;
    const valueHeight = 20.0;

    // 차트 영역 계산
    final chartWidth = size.width - (padding * 2);
    final chartHeight = size.height - (padding * 2) - labelHeight - valueHeight;

    print('차트 영역: $chartWidth x $chartHeight');

    // X축 스케일 계산
    final xScale = chartWidth / (data.length - 1);
    print('X축 스케일: $xScale (1단위당 픽셀)');

    // Y축 스케일 계산
    final valueRange = maxValue - minValue;
    final yScale = chartHeight / valueRange;
    print('Y축 스케일: $yScale (1단위당 픽셀)');

    // 각 포인트의 좌표 계산
    for (int i = 0; i < data.length; i++) {
      final pointData = data[i];
      final x = padding + (i * xScale);
      final y = size.height - padding - labelHeight - ((pointData.value - minValue) * yScale);

      print('포인트 ${i + 1} (${pointData.label}):');
      print('  - X: $x');
      print('  - Y: $y');
      print('  - 값: ${pointData.value}');
    }
    // _calculateValueMap(
    // valueMap = {
    //   'maxValue': maxValue,
    //   'minValue': minValue,
    //   'padding': padding,
    //   'labelHeight': labelHeight,
    //   'valueHeight': valueHeight,
    //   'chartWidth': chartWidth,
    //   'chartHeight': chartHeight,
    //   'xScale': xScale,
    //   'yScale': yScale,
    //   'valueRange': valueRange,
    // };
    // );

    print('================================');
  }

  void _drawBackground(Canvas canvas, Size size, Map<String, double> valueMap) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paint);
  }

  void _drawGrid(Canvas canvas, Size size, Map<String, double> valueMap) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // final maxValue = valueMap['maxValue']!;
    final minValue = valueMap['minValue']!;
    final padding = valueMap['padding']!;
    // const labelHeight = 30.0;
    // const valueHeight = 20.0;
    final chartHeight = valueMap['chartHeight']!;
    final valueRange = valueMap['valueRange']!;

    // 수평 격자선 그리기 (5개 구간)
    for (int i = 0; i <= 5; i++) {
      final y = padding + (chartHeight * i / 5);
      final value = minValue + (valueRange * (5 - i) / 5);

      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        paint,
      );

      // Y축 값 표시
      final textPainter = TextPainter(
        text: TextSpan(
          text: value.round().toString(),
          style: valueStyle ??
              const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(5, y - textPainter.height / 2),
      );
    }
  }

  void _drawLine(Canvas canvas, Size size, Map<String, double> valueMap) {
    if (data.length < 2) return;

    // final maxValue = valueMap['maxValue']!;
    final minValue = valueMap['minValue']!;
    final padding = valueMap['padding']!;
    final labelHeight = valueMap['labelHeight']!;
    // const valueHeight = 20.0;
    // final chartWidth = valueMap['chartWidth']!;
    // final chartHeight = valueMap['chartHeight']!;

    // 스케일 계산
    final xScale = valueMap['xScale']!;
    // final valueRange = valueMap['valueRange']!;
    final yScale = valueMap['yScale']!;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 라인 그리기
    final path = Path();
    bool isFirst = true;

    for (int i = 0; i < data.length; i++) {
      final pointData = data[i];
      final x = padding + (i * xScale);
      final y = size.height - padding - labelHeight - ((pointData.value - minValue) * yScale);

      if (isFirst) {
        path.moveTo(x, y);
        isFirst = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawPoints(Canvas canvas, Size size, Map<String, double> valueMap) {
    // final maxValue = valueMap['maxValue']!;
    final minValue = valueMap['minValue']!;
    final padding = valueMap['padding']!;
    final labelHeight = valueMap['labelHeight']!;
    // const valueHeight = 20.0;
    // final chartWidth = valueMap['chartWidth']!;
    // final chartHeight = valueMap['chartHeight']!;

    // 스케일 계산
    final xScale = valueMap['xScale']!;
    // final valueRange = valueMap['valueRange']!;
    final yScale = valueMap['yScale']!;

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    // 각 포인트 그리기
    for (int i = 0; i < data.length; i++) {
      final pointData = data[i];
      final x = padding + (i * xScale);
      final y = size.height - padding - labelHeight - ((pointData.value - minValue) * yScale);

      // 원 그리기
      canvas.drawCircle(Offset(x, y), 4.0, paint);

      // 흰색 테두리
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(Offset(x, y), 4.0, borderPaint);
    }
  }

  void _drawLabels(Canvas canvas, Size size, Map<String, double> valueMap) {
    final padding = valueMap['padding']!;
    final labelHeight = valueMap['labelHeight']!;
    // final chartWidth = valueMap['chartWidth']!;
    final xScale = valueMap['xScale']!;

    // 각 라벨 그리기
    for (int i = 0; i < data.length; i++) {
      final pointData = data[i];
      final x = padding + (i * xScale);
      final labelY = size.height - padding - labelHeight + 5;

      final textPainter = TextPainter(
        text: TextSpan(
          text: pointData.label,
          style: labelStyle ??
              const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          labelY,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LineData {
  final String label;
  final double value;

  LineData({
    required this.label,
    required this.value,
  });
}

// 사용 예시를 위한 위젯
class CustomLineChartExample extends StatelessWidget {
  const CustomLineChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    final sampleData = [
      LineData(label: '월', value: 1200),
      LineData(label: '화', value: 1500),
      LineData(label: '수', value: 900),
      LineData(label: '목', value: 2000),
      LineData(label: '금', value: 800),
      LineData(label: '토', value: 1700),
      LineData(label: '일', value: 1800),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('커스텀 라인 차트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Canvas로 직접 그린 라인 차트',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: CustomLineChart(
                data: sampleData,
                lineColor: Colors.blue,
                lineWidth: 3.0,
                showGrid: true,
                showLabels: true,
                showPoints: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
