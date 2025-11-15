import 'package:flutter/material.dart';

class SignupArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors
          .white // The color of the container
      ..style = PaintingStyle.fill;

    final path = Path();
    // Start below the top on the left side
    path.moveTo(0, size.height * 0.3);

    // Create a curve that arcs upwards towards the center
    path.quadraticBezierTo(
      size.width / 2, // Control point X
      size.height * 0.2, // Control point Y (higher than the start/end)
      size.width, // End point X
      size.height * 0.3, // End point Y
    );

    // Draw down to the bottom corners to fill the rest of the screen
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
