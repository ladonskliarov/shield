import 'package:flutter/material.dart';

class CornerClipper extends CustomClipper<Path> {
  final bool cutTopLeft;
  final bool cutTopRight;
  final bool cutBottomLeft;
  final bool cutBottomRight;
  final double cutSize;

  CornerClipper({
    this.cutTopLeft = false,
    this.cutTopRight = false,
    this.cutBottomLeft = false,
    this.cutBottomRight = false,
    this.cutSize = 30.0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    if (cutTopLeft) {
      path.moveTo(0, cutSize);
      path.lineTo(cutSize, 0);
    } else {
      path.moveTo(0, 0);
    }

    if (cutTopRight) {
      path.lineTo(size.width - cutSize, 0);
      path.lineTo(size.width, cutSize);
    } else {
      path.lineTo(size.width, 0);
    }

    if (cutBottomRight) {
      path.lineTo(size.width, size.height - cutSize);
      path.lineTo(size.width - cutSize, size.height);
    } else {
      path.lineTo(size.width, size.height);
    }

    if (cutBottomLeft) {
      path.lineTo(cutSize, size.height);
      path.lineTo(0, size.height - cutSize);
    } else {
      path.lineTo(0, size.height);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CornerClipper oldClipper) {
    return oldClipper.cutTopLeft != cutTopLeft ||
        oldClipper.cutTopRight != cutTopRight ||
        oldClipper.cutBottomLeft != cutBottomLeft ||
        oldClipper.cutBottomRight != cutBottomRight ||
        oldClipper.cutSize != cutSize;
  }
}