import 'package:flutter/material.dart';
class CustomShape extends CustomPainter {
  final Color bgColor;

  CustomShape(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = bgColor;
    var path = Path();
    path.lineTo(-10, 0);
    path.lineTo(0, -12);
    path.lineTo(10, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


class DrawTriangleShape extends CustomPainter {
  final Color color;
  DrawTriangleShape(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint painter = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(size.width, size.height);
   path.lineTo(size.width + size.width, size.height -  size.height);
   path.lineTo(size.width -  size.width, size.height -  size.height);
   canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}