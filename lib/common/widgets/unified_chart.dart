import 'package:flutter/material.dart';
import 'package:flutter_chart/common/widgets/combined_chart.dart';
import 'dart:math' as math;

class UnifiedChart extends StatefulWidget {
  final List<ChartData> data;
  final Color barColor;
  final Color lineColor;
  final bool showGrid;
  final bool showLabels;
  final bool showPoints;

  const UnifiedChart({
    super.key,
    required this.data,
    this.barColor = Colors.blue,
    this.lineColor = Colors.green,
    this.showGrid = true,
    this.showLabels = true,
    this.showPoints = true,
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
            data: widget.data,
            barColor: widget.barColor,
            lineColor: widget.lineColor,
            showGrid: widget.showGrid,
            showLabels: widget.showLabels,
            showPoints: widget.showPoints,
          ),
        );
      },
    );
  }
}

class _UnifiedChartPainter extends CustomPainter {
  final List<ChartData> data;
  final Color barColor;
  final Color lineColor;
  final bool showGrid;
  final bool showLabels;
  final bool showPoints;

  _UnifiedChartPainter({
    required this.data,
    required this.barColor,
    required this.lineColor,
    required this.showGrid,
    required this.showLabels,
    required this.showPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // 1. 좌표 계산 가이드
    final coordinates = _calculateCoordinates(size);

    // 2. 배경 그리기
    _drawBackground(canvas, size);

    double labelWidth = 0.0;
    double totalGridWidth = 0.0;

    // 3. 격자 그리기
    if (showGrid) {
      labelWidth = _drawGrid(
        canvas: canvas,
        size: size,
        maxValue: coordinates['maxValue'],
        minValue: coordinates['minValue'],
        padding: coordinates['padding'],
        labelHeight: coordinates['labelHeight'],
        valueHeight: coordinates['valueHeight'],
        chartHeight: coordinates['chartHeight'],
        valueRange: coordinates['valueRange'],
      );
    }

    totalGridWidth = (coordinates['barWidth'] * data.length) +
        (coordinates['barSpacing'] * (data.length - 1)) -
        labelWidth * 2 -
        coordinates['padding'] * 2;
    final chartStartX = (totalGridWidth + labelWidth) / 2;
    // 4. 막대 그리기 (배경)
    _drawBars(
      canvas: canvas,
      size: size,
      maxValue: coordinates['maxValue'],
      minValue: coordinates['minValue'],
      padding: coordinates['padding'],
      labelHeight: coordinates['labelHeight'],
      valueHeight: coordinates['valueHeight'],
      chartHeight: coordinates['chartHeight'],
      valueRange: coordinates['valueRange'],
      barWidth: coordinates['barWidth'],
      barSpacing: coordinates['barSpacing'],
      labelWidth: labelWidth,
      totalBarWidth: totalGridWidth,
      startX: chartStartX,
    );

    // 5. 라인 그리기 (전경)
    _drawLine(
      canvas: canvas,
      size: size,
      maxValue: coordinates['maxValue'],
      minValue: coordinates['minValue'],
      padding: coordinates['padding'],
      labelHeight: coordinates['labelHeight'],
      valueHeight: coordinates['valueHeight'],
      chartHeight: coordinates['chartHeight'],
      valueRange: coordinates['valueRange'],
      barWidth: coordinates['barWidth'],
      barSpacing: coordinates['barSpacing'],
      totalBarWidth: totalGridWidth,
      startX: chartStartX,
    );

    // 6. 포인트 그리기
    if (showPoints) {
      _drawPoints(
        canvas: canvas,
        size: size,
        maxValue: coordinates['maxValue'],
        minValue: coordinates['minValue'],
        padding: coordinates['padding'],
        labelHeight: coordinates['labelHeight'],
        valueHeight: coordinates['valueHeight'],
        chartHeight: coordinates['chartHeight'],
        valueRange: coordinates['valueRange'],
        barWidth: coordinates['barWidth'],
        barSpacing: coordinates['barSpacing'],
        startX: chartStartX,
      );
    }

    // 7. 라벨 그리기
    if (showLabels) {
      _drawLabels(
        canvas: canvas,
        size: size,
        padding: coordinates['padding'],
        labelHeight: coordinates['labelHeight'],
        barWidth: coordinates['barWidth'],
        barSpacing: coordinates['barSpacing'],
        totalBarWidth: totalGridWidth,
        startX: chartStartX,
      );
    }
  }

  // 통합 좌표 계산 가이드
  Map<String, dynamic> _calculateCoordinates(Size size) {
    // print('=== 통합 차트 좌표 계산 가이드 ===');
    // print('캔버스 크기: ${size.width} x ${size.height}');
    // print('데이터 개수: ${data.length}');

    // 최대값과 최소값 찾기 (최소값은 0으로 고정)
    final maxValue = data.map((d) => d.value).reduce(math.max);
    final minValue = 0.0; // 최소값을 0으로 고정
    // print('최대값: $maxValue, 최소값: $minValue (고정)');

    // 여백 계산
    final padding = 40.0;
    final labelHeight = 30.0;
    final valueHeight = 20.0;

    // 차트 영역 계산
    // final chartWidth = size.width - (padding * 2);
    final chartWidth = size.width - (padding * 2);
    // final chartWidth = size.width - (padding * 2);
    final chartHeight = size.height - (padding * 2) - labelHeight - valueHeight;

    // print('차트 영역: ${chartWidth} x ${chartHeight}');

    // 막대 설정
    // final barWidth = 20.0;
    double barWidth = chartWidth / data.length;
    double barSpacing = barWidth * 0.5;
    barWidth = barWidth - barSpacing;
    final totalBarWidth =
        (barWidth * data.length) + (barSpacing * (data.length - 1));
    final startX = (size.width - totalBarWidth) / 2;

    // print('총 막대 너비: $totalBarWidth');
    // print('시작 X 좌표: $startX');

    // Y축 스케일 계산 (최소값부터 시작)
    final valueRange = maxValue - minValue;
    final yScale = chartHeight / valueRange;
    // print('Y축 스케일: $yScale (1단위당 픽셀)');

    // 각 데이터 포인트의 좌표 계산 (막대와 라인 동일)
    for (int i = 0; i < data.length; i++) {
      final pointData = data[i];
      final x =
          startX + (i * (barWidth + barSpacing)) + (barWidth / 2); // 막대 중심점
      final y = size.height -
          padding -
          labelHeight -
          ((pointData.value - minValue) * yScale);

      // print('포인트 ${i + 1} (${pointData.label}):');
      // print('  - X: $x');
      // print('  - Y: $y');
      // print('  - 값: ${pointData.value}');
      // print(
      // '  - 막대 중심: ${startX + (i * (barWidth + barSpacing)) + (barWidth / 2)}');
    }
    // print('================================');
    return {
      'maxValue': maxValue,
      'minValue': minValue,
      'padding': padding,
      'labelHeight': labelHeight,
      'valueHeight': valueHeight,
      'chartWidth': chartWidth,
      'chartHeight': chartHeight,
      // 'startX': startX,
      'yScale': yScale,
      'barWidth': barWidth,
      'barSpacing': barSpacing,
      // 'totalBarWidth': totalBarWidth,
      'valueRange': valueRange,
    };
  }

  void _drawBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paint);
  }

  double _drawGrid(
      {required Canvas canvas,
      required Size size,
      required double maxValue,
      required double minValue,
      required double padding,
      required double labelHeight,
      required double valueHeight,
      required double chartHeight,
      required double valueRange}) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    List<double> valueWidths = [];
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
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      valueWidths.add(textPainter.width);

      textPainter.paint(
        canvas,
        Offset(5, y - textPainter.height / 2),
      );
    }
    final maxWidth = valueWidths.map((d) => d).reduce(math.max);
    return maxWidth;
  }

  void _drawBars(
      {required Canvas canvas,
      required Size size,
      required double maxValue,
      required double minValue,
      required double padding,
      required double labelHeight,
      required double valueHeight,
      required double chartHeight,
      required double valueRange,
      required double barWidth,
      required double barSpacing,
      required double labelWidth,
      required double totalBarWidth,
      required double startX}) {
    // final startX = (totalBarWidth + labelWidth) / 2;

    final paint = Paint()
      ..color = barColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final pointData = data[i];
      final barX = startX + (i * (barWidth + barSpacing));
      final barHeight =
          (pointData.value - minValue) * (chartHeight / valueRange);
      final barY = size.height - padding - labelHeight - barHeight;

      canvas.drawRect(
        Rect.fromLTWH(barX, barY, barWidth, barHeight),
        paint,
      );
    }
  }

  void _drawLine(
      {required Canvas canvas,
      required Size size,
      required double maxValue,
      required double minValue,
      required double padding,
      required double labelHeight,
      required double valueHeight,
      required double chartHeight,
      required double valueRange,
      required double barWidth,
      required double barSpacing,
      required double totalBarWidth,
      required double startX}) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    bool isFirst = true;

    for (int i = 0; i < data.length; i++) {
      final pointData = data[i];
      final x = startX + (i * (barWidth + barSpacing)) + (barWidth / 2);
      final y = size.height -
          padding -
          labelHeight -
          ((pointData.value - minValue) * (chartHeight / valueRange));

      if (isFirst) {
        path.moveTo(x, y);
        isFirst = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawPoints(
      {required Canvas canvas,
      required Size size,
      required double maxValue,
      required double minValue,
      required double padding,
      required double labelHeight,
      required double valueHeight,
      required double chartHeight,
      required double valueRange,
      required double barWidth,
      required double barSpacing,
      required double startX}) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final pointData = data[i];
      final x = startX + (i * (barWidth + barSpacing)) + (barWidth / 2);
      final y = size.height -
          padding -
          labelHeight -
          ((pointData.value - minValue) * (chartHeight / valueRange));

      canvas.drawCircle(Offset(x, y), 6.0, paint);

      // 흰색 테두리
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(Offset(x, y), 6.0, borderPaint);
    }
  }

  void _drawLabels(
      {required Canvas canvas,
      required Size size,
      required double padding,
      required double labelHeight,
      required double barWidth,
      required double barSpacing,
      required double totalBarWidth,
      required double startX}) {
    for (int i = 0; i < data.length; i++) {
      final pointData = data[i];
      final x = startX + (i * (barWidth + barSpacing)) + (barWidth / 2);
      final y = size.height - padding + 5;

      final textPainter = TextPainter(
        text: TextSpan(
          text: pointData.label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
