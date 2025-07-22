import 'package:flutter/material.dart';

class ChartCoordinateGuide extends StatelessWidget {
  const ChartCoordinateGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '차트 좌표 계산 및 그리기 가이드',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 1단계: 캔버스 크기 계산
            _buildStepCard(
              '1단계: 캔버스 크기 계산',
              [
                '• 위젯의 전체 크기 (width, height) 측정',
                '• 여백 (padding) 계산',
                '• 실제 차트 영역 크기 = 전체 크기 - 여백',
                '• 좌표계 원점 (0,0)은 좌상단',
              ],
              Colors.blue,
            ),
            const SizedBox(height: 12),

            // 2단계: 데이터 스케일링
            _buildStepCard(
              '2단계: 데이터 스케일링',
              [
                '• 데이터의 최소값, 최대값 찾기',
                '• Y축 스케일 = (차트 높이 - 여백) / (최대값 - 최소값)',
                '• X축 스케일 = (차트 너비 - 여백) / (데이터 개수 - 1)',
                '• 데이터 정규화: (값 - 최소값) × Y축 스케일',
              ],
              Colors.green,
            ),
            const SizedBox(height: 12),

            // 3단계: 좌표 변환
            _buildStepCard(
              '3단계: 좌표 변환',
              [
                '• 데이터 좌표 → 화면 좌표 변환',
                '• X 좌표 = 인덱스 × X축 스케일 + 여백',
                '• Y 좌표 = 차트 높이 - (정규화된 값 + 여백)',
                '• Flutter 좌표계는 Y축이 아래로 증가',
              ],
              Colors.orange,
            ),
            const SizedBox(height: 12),

            // 4단계: 그리기
            _buildStepCard(
              '4단계: 그리기',
              [
                '• Canvas 객체 생성',
                '• Paint 객체로 스타일 설정',
                '• 막대 차트: drawRect() 메서드 사용',
                '• 라인 차트: drawLine() 또는 drawPath() 메서드 사용',
                '• 점 표시: drawCircle() 메서드 사용',
              ],
              Colors.purple,
            ),
            const SizedBox(height: 12),

            // 코드 예시
            _buildCodeExample(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(String title, List<String> steps, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          ...steps.map((step) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  step,
                  style: const TextStyle(fontSize: 12),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCodeExample() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '코드 예시 (막대 차트 그리기):',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '// 좌표 계산\n'
            'double x = index * xScale + padding;\n'
            'double y = chartHeight - (normalizedValue + padding);\n'
            'double barHeight = normalizedValue;\n\n'
            '// 막대 그리기\n'
            'canvas.drawRect(\n'
            '  Rect.fromLTWH(x, y, barWidth, barHeight),\n'
            '  paint,\n'
            ');',
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
