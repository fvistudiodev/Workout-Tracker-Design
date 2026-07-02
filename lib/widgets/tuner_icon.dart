import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The ≡⊟ sliders/filter icon used throughout the app
class TunerIcon extends StatelessWidget {
  final double size;
  final Color color;

  const TunerIcon({
    super.key,
    this.size = 18,
    this.color = AppColors.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TunerPainter(color: color),
      ),
    );
  }
}

class _TunerPainter extends CustomPainter {
  final Color color;
  _TunerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Three horizontal lines
    final lineY = [h * 0.2, h * 0.5, h * 0.8];
    for (final y in lineY) {
      canvas.drawLine(Offset(0, y), Offset(w, y), paint);
    }

    // Three circle knobs — offset positions like the reference icon
    final knobPositions = [
      Offset(w * 0.65, lineY[0]),
      Offset(w * 0.35, lineY[1]),
      Offset(w * 0.65, lineY[2]),
    ];
    for (final pos in knobPositions) {
      // White circle cutout
      canvas.drawCircle(pos, w * 0.13, Paint()..color = AppColors.cardBackground..style = PaintingStyle.fill);
      canvas.drawCircle(pos, w * 0.13, paint);
    }
  }

  @override
  bool shouldRepaint(_TunerPainter oldDelegate) => oldDelegate.color != color;
}
