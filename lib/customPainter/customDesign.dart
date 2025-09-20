import 'package:flutter/material.dart';
import 'dart:math';

class DoubleWavePainter extends CustomPainter {
  final double animation;
  final Color color1;
  final Color color2;

  DoubleWavePainter({required this.animation, required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // First Wave
    Path path1 = Path();
    path1.moveTo(0, size.height * 0.8);
    for (double i = 0; i <= size.width; i++) {
      double y = 20 *
          sin((i / size.width * 2 * pi) + (animation * 2 * pi)) +
          size.height * 0.8;
      path1.lineTo(i, y);
    }
    path1.lineTo(size.width, 0);
    path1.lineTo(0, 0);
    path1.close();

    paint.shader = LinearGradient(
      colors: [color1, color2],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path1, paint);

    // Second Wave (slower, overlapping)
    Path path2 = Path();
    path2.moveTo(0, size.height * 0.8);
    for (double i = 0; i <= size.width; i++) {
      double y = 15 *
          sin((i / size.width * 2 * pi) + (animation * 2 * pi * 0.6)) +
          size.height * 0.8;
      path2.lineTo(i, y);
    }
    path2.lineTo(size.width, 0);
    path2.lineTo(0, 0);
    path2.close();

    paint.shader = LinearGradient(
      colors: [color2.withOpacity(0.6), color1.withOpacity(0.6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant DoubleWavePainter oldDelegate) => true;
}
