


import 'package:flutter/material.dart';

extension Styling on Text {
  Text withStyle({double? fontSize, Color? color,}) {
     String? text = data;
     return Text(
      text!,
      style: TextStyle(fontSize: fontSize, color: color),
    );
   }
}