import 'package:flutter/material.dart';

class BCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * -0.00125, size.height * -0.002);
    path.lineTo(size.width, size.height * -0.002);
    path.lineTo(size.width, size.height * 0.96);
    path.quadraticBezierTo(size.width * 0.8128125, size.height * 1.001,
        size.width * 0.49875, size.height);
    path.quadraticBezierTo(
        size.width * 0.1871875, size.height, 0, size.height * 0.96);
    path.lineTo(size.width * -0.00125, size.height * -0.002);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

