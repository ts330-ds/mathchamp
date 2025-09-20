import 'package:flutter/material.dart';

class MathBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.black.withValues(alpha: 0.2), // very light
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );

    final symbols = ["+", "-", "×", "÷"];
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (double x = 20; x < size.width; x += 80) {
      for (double y = 40; y < size.height; y += 80) {
        final symbol = symbols[(x.toInt() + y.toInt()) % symbols.length];
        textPainter.text = TextSpan(text: symbol, style: textStyle);
        textPainter.layout();
        textPainter.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
