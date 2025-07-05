import 'dart:math' show pi;
import 'package:flutter/material.dart';

final class EzRotateOnTap extends StatefulWidget {
  final Widget child;

  const EzRotateOnTap({super.key,   required this.child});

  @override
  State<StatefulWidget> createState() {
    return _RotateState();
  }
}

class _RotateState extends State<EzRotateOnTap> {
  double _angle =  0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState((){_angle = pi;}),
      onTapUp: (_) => setState((){_angle = 0;}),
      child: Transform.rotate(
        angle: _angle,
        child: widget.child,
      ),
    );
  }
}