import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/workout_models.dart';

/// Line chart for body weight progress over time.
/// — Lime line with soft fill below
/// — X-axis date labels
/// — Y-axis range padded by ±3 lbs around data
class WeightLineChart extends StatelessWidget {
  final List<WeightDataPoint> data;
  final double height;

  const WeightLineChart({
    super.key,
    required this.data,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    if (data.length < 2) return SizedBox(height: height);

    return SizedBox(
      height: height + 24,
      child: CustomPaint(
        painter: _LineChartPainter(data: data),
        size: Size.infinite,
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<WeightDataPoint> data;

  _LineChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final chartHeight = size.height - 24.0;
    final chartWidth = size.width;

    // Y-range: data min/max ± padding
    final weights = data.map((d) => d.weightLbs).toList();
    final minW = weights.reduce((a, b) => a < b ? a : b) - 4;
    final maxW = weights.reduce((a, b) => a > b ? a : b) + 4;
    final rangeW = maxW - minW;

    // Map data point → canvas Offset
    Offset toOffset(int index, double weight) {
      final x = (index / (data.length - 1)) * chartWidth;
      final y = chartHeight - ((weight - minW) / rangeW) * (chartHeight * 0.85);
      return Offset(x, y);
    }

    final points = List.generate(data.length, (i) => toOffset(i, data[i].weightLbs));

    // ── Fill area ────────────────────────────────────────────────────────────
    final fillPath = Path();
    fillPath.moveTo(points.first.dx, chartHeight);
    fillPath.lineTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      fillPath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    fillPath.lineTo(points.last.dx, chartHeight);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, chartHeight),
        [AppColors.weightFillTop, AppColors.weightFillBottom],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // ── Line ────────────────────────────────────────────────────────────────
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    final linePaint = Paint()
      ..color = AppColors.weightLineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);

    // ── Dots on each data point ──────────────────────────────────────────────
    final dotPaint = Paint()
      ..color = AppColors.weightLineColor
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = AppColors.cardBackground
      ..style = PaintingStyle.fill;

    for (final p in points) {
      canvas.drawCircle(p, 5, dotBorderPaint);
      canvas.drawCircle(p, 3.5, dotPaint);
    }

    // ── X-axis labels (sparse: first, middle, last) ──────────────────────────
    final labelIndices = _sparseIndices(data.length, 4);
    final labelPainter = TextPainter(textDirection: TextDirection.ltr);

    for (final i in labelIndices) {
      final d = data[i];
      final label = '${_monthAbbr(d.date.month)} ${d.date.day}';
      labelPainter.text = TextSpan(
        text: label,
        style: AppTextStyles.chartAxisLabel,
      );
      labelPainter.layout();
      final x = (i / (data.length - 1)) * chartWidth - labelPainter.width / 2;
      labelPainter.paint(canvas, Offset(x.clamp(0, chartWidth - labelPainter.width), chartHeight + 6));
    }
  }

  List<int> _sparseIndices(int count, int max) {
    if (count <= max) return List.generate(count, (i) => i);
    final result = <int>[];
    for (int i = 0; i < max; i++) {
      result.add(((i / (max - 1)) * (count - 1)).round());
    }
    return result;
  }

  String _monthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  @override
  bool shouldRepaint(_LineChartPainter old) => old.data != data;
}
