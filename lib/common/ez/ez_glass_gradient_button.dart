import 'package:flutter/material.dart';

import 'ez_glass_container.dart';
import 'ez_gradient.dart';
import 'ez_scale.dart';


final class EzGlassGradientButton extends StatelessWidget {
  final Widget? child;
  final GestureTapCallback? onTap;

  const EzGlassGradientButton({super.key, this.child, this.onTap});

  @override
  Widget build(Object context) {
    return EzScaleOnTap(
        onTap: onTap,
        child: EzGradient(
            colors: [Colors.yellow.shade300, Colors.red.shade200],
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: EzGlassContainer(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: child,
                ),
              ),
            )));
  }
}
