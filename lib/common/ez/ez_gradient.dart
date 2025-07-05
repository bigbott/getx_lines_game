import 'package:flutter/material.dart';

final class EzGradient extends StatelessWidget {
  final List<Color> colors;
  final Widget child;

  const EzGradient({
    super.key,
    required this.colors,
    required this.child,
  });

  @override
  Widget build(Object context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 0.5,
          colors: colors,
          tileMode: TileMode.repeated,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
