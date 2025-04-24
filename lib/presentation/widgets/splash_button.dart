
import 'package:flutter/material.dart';

import '../../colors.dart';
import 'corner_clipper.dart';

class SplashButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color color;
  final TextStyle? textStyle;

  const SplashButton({
    super.key,
    required this.onTap,
    required this.text,
    this.color = btnColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CornerClipper(cutTopRight: true, cutBottomLeft: true, cutSize: 20),
      child: Material(
        color: color,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white24,
          child: SizedBox(
            width: 130,
            height: 60,
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: textStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Viga',
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
