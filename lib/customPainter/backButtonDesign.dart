import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SquareButtonPainter extends CustomPainter {
  BuildContext context;

  SquareButtonPainter({required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Gradient fill
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColorLight], // purple → blue
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    // Rounded square
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    canvas.drawRRect(rrect, paint);

    // Border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rrect, borderPaint);

    // Shadow for 3D effect
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(rrect.shift(const Offset(3, 3)), shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}