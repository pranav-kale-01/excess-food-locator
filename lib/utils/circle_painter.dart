import 'package:flutter/material.dart';

/// Draws a circle if placed into a square widget.
/// https://stackoverflow.com/a/61246388/1321917
class CirclePainter extends CustomPainter {
  final Offset offset;

  const CirclePainter( {
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFEC9F46),
          Color(0xFFDF5216),
          Color(0xFFEC9F46),
          Color(0x25EC9F46),
        ],
      ).createShader(Rect.fromCircle(
        center: offset,
        radius: 600,
      ));

    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}