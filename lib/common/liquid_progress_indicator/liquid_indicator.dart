import 'package:flutter/material.dart';

import 'liquid_linear_progress_indicator.dart';

class LiquidProgressIndicator extends StatefulWidget {
  final double? height;
  final double? width;
  final Color? bgColor;
  final Color? liquidColor;
  final double? fontSize;
  final int? duration;
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final bool? showPercentage;
  final bool? isHorizontal;
  final String? title;
  final double? horizontalPadding;
  final double? verticalPadding;

  const LiquidProgressIndicator({
    super.key,
    this.height = 100,
    this.width = double.infinity,
    this.bgColor = Colors.white,
    this.liquidColor = Colors.blue,
    this.fontSize = 20,
    this.duration = 5,
    this.borderRadius = 12,
    this.borderWidth = 0.5,
    this.borderColor = Colors.black26,
    this.showPercentage = true,
    this.isHorizontal = true,
    this.title = '',
    this.horizontalPadding = 10,
    this.verticalPadding = 10,
  });

  @override
  State<StatefulWidget> createState() => LiquidProgressIndicatorState();
}

class LiquidProgressIndicatorState extends State<LiquidProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration!),
    );

    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = _animationController.value * 100;
    return Center(
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding!,
          vertical: widget.verticalPadding!,
        ),
        child: LiquidLinearProgressIndicator(
          value: _animationController.value,
          backgroundColor: widget.bgColor,
          valueColor: AlwaysStoppedAnimation(widget.liquidColor!),
          borderRadius: widget.borderRadius,
          borderWidth: widget.borderWidth,
          borderColor: widget.borderColor,
          direction: widget.isHorizontal! ? Axis.horizontal : Axis.vertical,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // spacing: 10,
            children: [
              Text(
                widget.title!,
                style: TextStyle(
                  color: percentage < 50 ? widget.liquidColor : widget.bgColor,
                  fontSize: widget.fontSize! - 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              widget.showPercentage!
                  ? Text(
                      "${percentage.toStringAsFixed(0)}%",
                      style: TextStyle(
                        color: percentage < 50 ? widget.liquidColor : widget.bgColor,
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
