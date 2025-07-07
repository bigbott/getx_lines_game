import 'package:flutter/material.dart';

import 'ez_glass_container.dart';
import 'ez_gradient.dart';
import 'ez_scale.dart';

final class EzGlassGradientButton extends StatelessWidget {
  final Widget? child;
  final GestureTapCallback? onTap;
  final double? width;
  final double? height;

  const EzGlassGradientButton({
    super.key,
    this.child,
    this.onTap,
    this.width = double.infinity,
    this.height = 60,
  });

  @override
  Widget build(Object context) {
    return EzScaleOnTap(
        onTap: onTap,
        child: EzGradient(
            colors: [Colors.yellow.shade300, Colors.red.shade200],
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: EzGlassContainer(
                child: SizedBox(
                 width: width,
                 height: height,
                  child: Center(child: child),
                ),
              ),
            )));
  }
}
