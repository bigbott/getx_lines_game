import 'package:flutter/material.dart';

final class EzText extends StatelessWidget {
  final String data;
  final Color? color;
  final double? fontSize;

  const EzText(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(color: color, fontSize: fontSize),
    );
  }
}
