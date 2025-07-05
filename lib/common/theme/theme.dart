import 'package:flutter/material.dart';

final class Themes {
  Themes._();

  static final defaultTheme = ThemeData(
      colorScheme: ColorScheme.light(
    primary: Colors.white,
    primaryContainer: Colors.yellow.shade200,
    secondary: Colors.white.withAlpha(220),
    secondaryContainer: Colors.yellow.shade100,
    surface: Colors.green.shade900,
  ));

  static final darkGreenColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.white,
    onPrimary: Colors.white70,
    secondary: Colors.white70,
    onSecondary: Colors.green.shade900,
    error: Colors.red.shade200,
    onError: Colors.black,
    surface: Colors.green.shade900,
    onSurface: Colors.white,
  );
}
