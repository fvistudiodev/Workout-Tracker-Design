import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/workout_models.dart';

/// Renders a rounded-rect bar chart matching the reference design.
/// — Tallest/highlighted bar: lime (chartBarActive)
/// — Standard bars:  olive gradient (chartBarIdle → chartBarMid)
/// — Tooltip label floats above the active bar
class VolumeBarChart extends StatelessWidget {
  final List<ChartBar> bars;
  final double height;

  const VolumeBarChart({
    super.key,
    required this.bars,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    if (bars.isEmpty) return SizedBox(height: height);

    return SizedBox(
      height: height + 24, // extra bottom for axis labels
      child: CustomPaint(
        painter: _BarChartPainter(bars: bars),
        size: Size.infinite,
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<ChartBar> bars;

  _BarChartPainter({required this.bars});

  @override
  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;

    final chartHeight = size.height - 24.0; // reserve 24px for labels
    final maxValue = bars.map((b) => b.value).reduce((a, b) => a > b ? a : b);
    if (maxValue <= 0) return;

    final n = bars.length;
    const gapRatio = 0.35; // gap/barWidth ratio
    final totalWidth = size.width;
    // barWidth = totalWidth / (n + (n-1)*gapRatio)
    final barWidth = totalWidth / (n + (n - 1) * gapRatio);
    final gap = barWidth * gapRatio;
    const barRadius = Radius.circular(6);

    final labelPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < n; i++) {
      final bar = bars[i];
      final x = i * (barWidth + gap);
      final barH = (bar.value / maxValue) * (chartHeight * 0.85);
      final top = chartHeight - barH;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, top, barWidth, barH),
        barRadius,
      );

      if (bar.isHighlight) {
        // Lime bar
        final paint = Paint()
          ..color = AppColors.chartBarActive
          ..style = PaintingStyle.fill;
        canvas.drawRRect(rect, paint);

        // Tooltip above the bar
        _drawTooltip(canvas, bar.value, x + barWidth / 2, top - 8);
      } else {
        // Olive bar — subtle 2-stop vertical gradient
        final paint = Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.chartBarMid, AppColors.chartBarIdle],
          ).createShader(Rect.fromLTWH(x, top, barWidth, barH))
          ..style = PaintingStyle.fill;
        canvas.drawRRect(rect, paint);
      }

      // X-axis label
      labelPainter.text = TextSpan(
        text: bar.label,
        style: AppTextStyles.chartAxisLabel,
      );
      labelPainter.layout(maxWidth: barWidth + gap);
      labelPainter.paint(
        canvas,
        Offset(
          x + barWidth / 2 - labelPainter.width / 2,
          chartHeight + 6,
        ),
      );
    }
  }

  void _drawTooltip(Canvas canvas, double value, double cx, double tipBottom) {
    final label = value >= 1000
        ? '${(value / 1000).toStringAsFixed(1)}k'
        : value.toInt().toString();

    final tp = TextPainter(
      text: TextSpan(text: label, style: AppTextStyles.chartTooltip),
      textDirection: TextDirection.ltr,
    )..layout();

    const hPad = 10.0;
    const vPad = 5.0;
    final tooltipW = tp.width + hPad * 2;
    final tooltipH = tp.height + vPad * 2;
    final left = cx - tooltipW / 2;
    final top = tipBottom - tooltipH - 2;

    // Tooltip pill background
    final bgPaint = Paint()
      ..color = AppColors.cardBackgroundLight
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, tooltipW, tooltipH),
        const Radius.circular(8),
      ),
      bgPaint,
    );

    tp.paint(canvas, Offset(left + hPad, top + vPad));
  }

  @override
  bool shouldRepaint(_BarChartPainter old) => old.bars != bars;
}
