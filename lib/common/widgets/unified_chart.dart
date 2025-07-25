import 'package:flutter/material.dart';
import 'package:flutter_chart/common/widgets/combined_chart.dart';
import 'dart:math' as math;

class UnifiedChart extends StatefulWidget {
  final List<ChartData> barData;
  final List<ChartData> lineData;
  final Color barColor;
  final Color lineColor;
  final bool showGrid;
  final bool showLabels;
  final bool showPoints;
  final double lineWidth;
  final double barWidth;
  final double padding;
  final double gridCount;

  const UnifiedChart({
    super.key,
    required this.barData,
    required this.lineData,
    this.barColor = Colors.blue,
    this.lineColor = Colors.green,
    this.showGrid = true,
    this.showLabels = true,
    this.showPoints = true,
    this.lineWidth = 3.0,
    this.barWidth = 30.0,
    this.padding = 40,
    this.gridCount = 5,
  });

  @override
  State<UnifiedChart> createState() => _UnifiedChartState();
}

class _UnifiedChartState extends State<UnifiedChart> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _UnifiedChartPainter(
            barData: widget.barData,
            lineData: widget.lineData,
            barColor: widget.barColor,
            lineColor: widget.lineColor,
            showGrid: widget.showGrid,
            showLabels: widget.showLabels,
            showPoints: widget.showPoints,
            lineWidth: widget.lineWidth,
            barWidth: widget.barWidth,
            padding: widget.padding,
            gridCount: widget.gridCount,
          ),
        );
      },
    );
  }
}

class _UnifiedChartPainter extends CustomPainter {
  final List<ChartData> barData;
  final List<ChartData> lineData;
  final Color barColor;
  final Color lineColor;
  final bool showGrid;
  final bool showLabels;
  final bool showPoints;
  final double lineWidth;
  final double barWidth;
  final double padding;
  final double gridCount;
  _UnifiedChartPainter({
    required this.barData,
    required this.lineData,
    required this.barColor,
    required this.lineColor,
    required this.showGrid,
    required this.showLabels,
    required this.showPoints,
    required this.lineWidth,
    required this.barWidth,
    required this.padding,
    required this.gridCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (barData.isEmpty) return;

    // 1. [공통] 좌표 계산
    final maxValue = barData.map((d) => d.value).reduce(math.max);
    const minValue = 0.0; // 최소값을 0으로 고정

    // 여백 계산
    const labelHeight = 30.0;
    const valueHeight = 20.0;

    // 차트 영역 계산
    final chartWidth = (size.width - (padding * 2)) - barWidth;
    final chartHeight = size.height - (padding * 2) - labelHeight - valueHeight;

    final xScale = chartWidth / (barData.length - 1);

    // Y축 스케일 계산 (최소값부터 시작)
    final valueRange = maxValue - minValue;
    final yScale = chartHeight / valueRange;

    Map<String, double> barValue = {
      'maxValue': maxValue,
      'minValue': minValue,
      'padding': padding,
      'labelHeight': labelHeight,
      'valueHeight': valueHeight,
      'chartWidth': chartWidth,
      'chartHeight': chartHeight,
      'yScale': yScale,
      'xScale': xScale,
      'valueRange': valueRange,
    };

    // 2. 배경 그리기
    _drawBackground(canvas, size);

    // double labelWidth = 0.0;
    // double totalGridWidth = 0.0;

    // 3. 격자 그리기
    if (showGrid) {
      _drawGrid(canvas, size, barValue);
    }

    // 4. 막대 그리기 (배경)
    _drawBars(canvas, size, barValue);

    // 5. 라인 그리기 (전경)
    _drawLine(canvas, size, barValue);

    // 6. 포인트 그리기
    if (showPoints) {
      _drawPoints(canvas, size, barValue);
    }

    // 7. 라벨 그리기
    if (showLabels) {
      _drawLabels(canvas, size, barValue);
    }
  }

  void _drawBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
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
    for (int i = 0; i <= gridCount; i++) {
      final y = padding + (chartHeight * i / gridCount);
      final value = minValue + (valueRange * (gridCount - i) / gridCount);

      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        paint,
      );

      // Y축 값 표시
      final textPainter = TextPainter(
        text: TextSpan(
          text: value.round().toString(),
          style: const TextStyle(
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

  void _drawBars(Canvas canvas, Size size, Map<String, double> valueMap) {
    final minValue = valueMap['minValue']!;
    final padding = valueMap['padding']!;
    final labelHeight = valueMap['labelHeight']!;
    final chartHeight = valueMap['chartHeight']!;
    final valueRange = valueMap['valueRange']!;
    // const barWidth = 20.0;

    // 스케일 계산
    final xScale = valueMap['xScale']!;

    final paint = Paint()
      ..color = barColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < barData.length; i++) {
      final pointData = barData[i];
      final barX = padding + (i * xScale);
      final barHeight = (pointData.value - minValue) * (chartHeight / valueRange);
      final barY = size.height - padding - labelHeight - barHeight - 20;

      canvas.drawRect(
        Rect.fromLTWH(barX, barY, barWidth, barHeight),
        paint,
      );
    }
  }

  void _drawLine(Canvas canvas, Size size, Map<String, double> valueMap) {
    if (lineData.length < 2) return;

    final minValue = valueMap['minValue']!;
    final padding = valueMap['padding']!;
    final labelHeight = valueMap['labelHeight']!;

    // 스케일 계산
    final xScale = valueMap['xScale']!;
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

    for (int i = 0; i < lineData.length; i++) {
      final pointData = lineData[i];
      final x = padding + (i * xScale) + (barWidth / 2);
      final y = size.height - padding - labelHeight - ((pointData.value - minValue) * yScale) - 20;

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
    final minValue = valueMap['minValue']!;
    final padding = valueMap['padding']!;
    final labelHeight = valueMap['labelHeight']!;
    // 스케일 계산
    final xScale = valueMap['xScale']!;
    final yScale = valueMap['yScale']!;

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < lineData.length; i++) {
      final pointData = lineData[i];
      final x = padding + (i * xScale) + (barWidth / 2);
      final y = size.height - padding - labelHeight - ((pointData.value - minValue) * yScale) - 20;

      canvas.drawCircle(Offset(x, y), 6.0, paint);

      // 흰색 테두리
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(Offset(x, y), 6.0, borderPaint);
    }
  }

  void _drawLabels(Canvas canvas, Size size, Map<String, double> valueMap) {
    final padding = valueMap['padding']!;
    final labelHeight = valueMap['labelHeight']!;
    // final chartWidth = valueMap['chartWidth']!;
    final xScale = valueMap['xScale']!;

    // 각 라벨 그리기
    for (int i = 0; i < lineData.length; i++) {
      final pointData = lineData[i];
      final x = padding + (i * xScale) + (barWidth / 2);
      final labelY = size.height - padding - labelHeight + 5;

      final textPainter = TextPainter(
        text: TextSpan(
          text: pointData.label,
          style: const TextStyle(
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
