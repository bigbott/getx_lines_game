import 'package:flutter/material.dart';
import 'package:get/get.dart';

final class _ScaleController extends GetxController {
  double _scale = 1.0;

  void change(value){
     _scale += value;
     update();
  } 
}

final class EzScaleOnTap1 extends GetView<_ScaleController> {
  final double? diff;
  final Widget child;
  
  const EzScaleOnTap1({super.key, this.diff = 0.05, required this.child});
  
  @override
  Widget build(BuildContext context) {
    Get.put<_ScaleController>(_ScaleController(),);
    return GestureDetector(
      onTapDown: (_) => controller.change(diff),
      onTapUp: (_) => controller.change(-diff!),
      child: GetBuilder<_ScaleController>(builder: (context) {
        return Transform.scale(
          scale: controller._scale,
          child: child,
        );
      }),
    ); 
  }
}

final class EzScaleOnTap extends StatefulWidget {
  final double? diff;
  final Widget child;
  final  GestureTapCallback? onTap;

  const EzScaleOnTap({super.key,  this.diff = -0.05, required this.child, this.onTap});

  @override
  State<StatefulWidget> createState() {
    return _ScaleState();
  }
}

class _ScaleState extends State<EzScaleOnTap> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _scale += widget.diff!),
      onTapUp: (_) => setState(() => _scale = 1.0),
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
