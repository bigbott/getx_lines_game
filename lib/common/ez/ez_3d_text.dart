

import 'package:flutter/material.dart';

class Ez3dText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final Color shadowColor;
  final int depth;

  const Ez3dText(this.text, {
    super.key,
   // required this.text,
    this.fontSize = 48,
    this.color = Colors.white,
    this.shadowColor = Colors.black,
    this.depth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Create shadow layers
        for (int i = depth; i > 0; i--)
          Positioned(
            left: i.toDouble(),
            top: i.toDouble(),
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: shadowColor.withValues(alpha: 0.3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        // Main text on top
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
