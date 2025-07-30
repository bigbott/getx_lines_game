import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EzBackButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color color;
  final double fontSize;
  final double chevronBottomPadding;

  const EzBackButton({
    super.key,
    this.text,
    this.onPressed,
    this.color = Colors.white,
    this.fontSize = 20,
     this.chevronBottomPadding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () => Get.back(),
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      ),
      child: text != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.baseline,
              // textBaseline: TextBaseline.ideographic,
              spacing: 5,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: chevronBottomPadding),
                  child: Text(
                    '\u2039',
                    style: TextStyle(
                      color: color,
                      fontSize: fontSize * 2.5,
                      height: 0.5,
                    ),
                  ),
                ),
                Text(
                  text!,
                  style: TextStyle(
                    color: color ,
                    fontSize: fontSize,
                  ),
                ),
              ],
            )
          : Icon(
              Icons.chevron_left,
              color: color,
              size: fontSize + 10,
            ),
    );
  }
}
