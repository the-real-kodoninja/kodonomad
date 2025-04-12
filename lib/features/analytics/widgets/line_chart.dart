// lib/features/analytics/widgets/line_chart.dart
import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  final Map<DateTime, int> data;
  final Color color;
  final String label;

  const LineChart({required this.data, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: LineChartPainter(data: data, color: color),
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final Map<DateTime, int> data;
  final Color color;

  LineChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final points = <Offset>[];
    final maxValue = data.values.isNotEmpty ? data.values.reduce((a, b) => a > b ? a : b) : 1;
    final days = data.keys.toList()..sort();
    if (days.isEmpty) return;

    final startDate = days.first;
    final endDate = days.last;
    final totalDays = endDate.difference(startDate).inDays + 1;

    for (var i = 0; i < totalDays; i++) {
      final date = startDate.add(Duration(days: i));
      final value = data[DateTime(date.year, date.month, date.day)] ?? 0;
      final x = (i / (totalDays - 1)) * size.width;
      final y = size.height - (value / maxValue) * size.height;
      points.add(Offset(x, y));
    }

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(points[i].dx, points[i].dy);
      } else {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, paint);

    // Draw axes
    final axisPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axisPaint); // X-axis
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), axisPaint); // Y-axis
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
