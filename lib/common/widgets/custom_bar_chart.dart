import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomBarChart extends StatefulWidget {
  final List<BarData> data;
  final double barWidth;
  final double barSpacing;
  final Color barColor;
  final Color backgroundColor;
  final bool showGrid;
  final bool showLabels;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const CustomBarChart({
    super.key,
    required this.data,
    this.barWidth = 30.0,
    this.barSpacing = 20.0,
    this.barColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.showGrid = true,
    this.showLabels = true,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _BarChartPainter(
            data: widget.data,
            barWidth: widget.barWidth,
            barSpacing: widget.barSpacing,
            barColor: widget.barColor,
            backgroundColor: widget.backgroundColor,
            showGrid: widget.showGrid,
            showLabels: widget.showLabels,
            labelStyle: widget.labelStyle,
            valueStyle: widget.valueStyle,
          ),
        );
      },
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<BarData> data;
  final double barWidth;
  final double barSpacing;
  final Color barColor;
  final Color backgroundColor;
  final bool showGrid;
  final bool showLabels;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  _BarChartPainter({
    required this.data,
    required this.barWidth,
    required this.barSpacing,
    required this.barColor,
    required this.backgroundColor,
    required this.showGrid,
    required this.showLabels,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // 1. 좌표 계산 가이드
    _calculateCoordinates(size);

    // 2. 배경 그리기
    _drawBackground(canvas, size);

    // 3. 격자 그리기
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    // 4. 막대 그리기
    _drawBars(canvas, size);

    // 5. 라벨 그리기
    if (showLabels) {
      _drawLabels(canvas, size);
    }
  }

  // 좌표 계산 가이드
  void _calculateCoordinates(Size size) {
    print('=== 좌표 계산 가이드 ===');
    print('캔버스 크기: ${size.width} x ${size.height}');
    print('데이터 개수: ${data.length}');

    // 최대값 찾기
    final maxValue = data.map((d) => d.value).reduce(math.max);
    print('최대값: $maxValue');

    // 여백 계산
    final padding = 40.0;
    final labelHeight = 30.0;
    final valueHeight = 20.0;

    // 차트 영역 계산
    final chartWidth = size.width - (padding * 2);
    final chartHeight = size.height - (padding * 2) - labelHeight - valueHeight;

    print('차트 영역: ${chartWidth} x ${chartHeight}');

    // 막대 간격 계산
    final totalBarWidth =
        (barWidth * data.length) + (barSpacing * (data.length - 1));
    final startX = (size.width - totalBarWidth) / 2;

    print('총 막대 너비: $totalBarWidth');
    print('시작 X 좌표: $startX');

    // Y축 스케일 계산
    final yScale = chartHeight / maxValue;
    print('Y축 스케일: $yScale (1단위당 픽셀)');

    // 각 막대의 좌표 계산
    for (int i = 0; i < data.length; i++) {
      final barData = data[i];
      final barX = startX + (i * (barWidth + barSpacing));
      final barHeight = barData.value * yScale;
      final barY = size.height - padding - labelHeight - barHeight;

      print('막대 ${i + 1} (${barData.label}):');
      print('  - X: $barX');
      print('  - Y: $barY');
      print('  - 너비: $barWidth');
      print('  - 높이: $barHeight');
      print('  - 값: ${barData.value}');
    }
    print('========================');
  }

  void _drawBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paint);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final maxValue = data.map((d) => d.value).reduce(math.max);
    final padding = 40.0;
    final labelHeight = 30.0;
    final valueHeight = 20.0;
    final chartHeight = size.height - (padding * 2) - labelHeight - valueHeight;

    // 수평 격자선 그리기 (5개 구간)
    for (int i = 0; i <= 5; i++) {
      final y = padding + (chartHeight * i / 5);
      final value = (maxValue * (5 - i) / 5).round();

      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        paint,
      );

      // Y축 값 표시
      final textPainter = TextPainter(
        text: TextSpan(
          text: value.toString(),
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

  void _drawBars(Canvas canvas, Size size) {
    final maxValue = data.map((d) => d.value).reduce(math.max);
    final padding = 40.0;
    final labelHeight = 30.0;
    final valueHeight = 20.0;
    final chartHeight = size.height - (padding * 2) - labelHeight - valueHeight;

    // 막대 간격 계산
    final totalBarWidth =
        (barWidth * data.length) + (barSpacing * (data.length - 1));
    final startX = (size.width - totalBarWidth) / 2;

    // Y축 스케일 계산
    final yScale = chartHeight / maxValue;

    final paint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    // 각 막대 그리기
    for (int i = 0; i < data.length; i++) {
      final barData = data[i];
      final barX = startX + (i * (barWidth + barSpacing));
      final barHeight = barData.value * yScale;
      final barY = size.height - padding - labelHeight - barHeight;

      // 막대 그리기
      final rect = Rect.fromLTWH(barX, barY, barWidth, barHeight);
      canvas.drawRect(rect, paint);

      // 막대 위에 값 표시
      final textPainter = TextPainter(
        text: TextSpan(
          text: barData.value.toString(),
          style: valueStyle ??
              const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          barX + (barWidth - textPainter.width) / 2,
          barY - textPainter.height - 5,
        ),
      );
    }
  }

  void _drawLabels(Canvas canvas, Size size) {
    final padding = 40.0;
    final labelHeight = 30.0;
    final valueHeight = 20.0;

    // 막대 간격 계산
    final totalBarWidth =
        (barWidth * data.length) + (barSpacing * (data.length - 1));
    final startX = (size.width - totalBarWidth) / 2;

    // 각 라벨 그리기
    for (int i = 0; i < data.length; i++) {
      final barData = data[i];
      final barX = startX + (i * (barWidth + barSpacing));
      final labelY = size.height - padding - labelHeight + 5;

      final textPainter = TextPainter(
        text: TextSpan(
          text: barData.label,
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
          barX + (barWidth - textPainter.width) / 2,
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

class BarData {
  final String label;
  final double value;

  BarData({
    required this.label,
    required this.value,
  });
}

// 사용 예시를 위한 위젯
class CustomBarChartExample extends StatelessWidget {
  const CustomBarChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    final sampleData = [
      BarData(label: '월', value: 1200),
      BarData(label: '화', value: 1500),
      BarData(label: '수', value: 900),
      BarData(label: '목', value: 2000),
      BarData(label: '금', value: 800),
      BarData(label: '토', value: 1700),
      BarData(label: '일', value: 1800),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('커스텀 막대그래프'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Canvas로 직접 그린 막대그래프',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: CustomBarChart(
                data: sampleData,
                barWidth: 40.0,
                barSpacing: 15.0,
                barColor: Colors.blue,
                showGrid: true,
                showLabels: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
