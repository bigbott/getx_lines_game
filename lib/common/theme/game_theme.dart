
import 'package:flutter/material.dart';

class GameColorScheme {
  static ColorScheme fromSurface(Color surfaceColor) {
    // Extract HSL values from surface color for intelligent color generation
    final HSLColor surfaceHsl = HSLColor.fromColor(surfaceColor);
    
    // Create primary color by shifting hue slightly and increasing saturation
    final Color primary = surfaceHsl
        .withHue((surfaceHsl.hue + 30) % 360)
        .withSaturation((surfaceHsl.saturation * 1.3).clamp(0.0, 1.0))
        .withLightness(0.8)
        .toColor();
    
    // Create secondary color with complementary hue
    final Color secondary = surfaceHsl
        .withHue((surfaceHsl.hue + 150) % 360)
        .withSaturation(0.6)
        .withLightness(0.8)
        .toColor();
    
    // Create tertiary color
    final Color tertiary = surfaceHsl
        .withHue((surfaceHsl.hue + 60) % 360)
        .withSaturation(0.5)
        .withLightness(0.8)
        .toColor();
    
    // Create error color (reddish, but harmonious with surface)
    final Color error = surfaceHsl
        .withHue(0)
        .withSaturation(0.8)
        .withLightness(0.8)
        .toColor();
    
    // Generate lighter and darker variants
    final Color onSurface = surfaceHsl.lightness > 0.5 
        ? Colors.black87 
        : Colors.white.withAlpha(230);
    
    final Color surfaceVariant = surfaceHsl
        .withLightness((surfaceHsl.lightness * 1.2).clamp(0.0, 1.0))
        .toColor();
    
    final Color outline = surfaceHsl
        .withSaturation((surfaceHsl.saturation * 0.3).clamp(0.0, 1.0))
        .withLightness(0.6)
        .toColor();
    
    return ColorScheme.dark(
      // Primary colors
      primary: primary,
      onPrimary: _getContrastingColor(primary),
      primaryContainer: primary.withValues(alpha: 0.8),
      onPrimaryContainer: _getContrastingColor(primary.withValues(alpha: 0.8)),
      
      // Secondary colors
      secondary: secondary,
      onSecondary: _getContrastingColor(secondary),
      secondaryContainer: secondary.withValues(alpha: 0.8),
      onSecondaryContainer: _getContrastingColor(secondary.withValues(alpha: 0.8)),
      
      // Tertiary colors
      tertiary: tertiary,
      onTertiary: _getContrastingColor(tertiary),
      tertiaryContainer: tertiary.withValues(alpha: 0.8),
      onTertiaryContainer: _getContrastingColor(tertiary.withValues(alpha: 0.8)),
      
      // Error colors
      error: error,
      onError: _getContrastingColor(error),
      errorContainer: error.withValues(alpha: 0.8),
      onErrorContainer: _getContrastingColor(error.withValues(alpha: 0.8)),
      
      // Surface colors
      surface: surfaceColor,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: _getContrastingColor(surfaceVariant),
      
      // Other colors
      outline: outline,
      outlineVariant: outline.withValues(alpha: 0.5),
      shadow: Colors.black,
      scrim: Colors.black.withValues(alpha: 0.8),
      inverseSurface: _getInverseColor(surfaceColor),
      onInverseSurface: _getContrastingColor(_getInverseColor(surfaceColor)),
      inversePrimary: _getInverseColor(primary),
      
      // Background (for older Flutter versions compatibility)
      background: surfaceColor,
      onBackground: onSurface,
    );
  }
  
  // Helper method to get contrasting color (white or black) based on luminance
  static Color _getContrastingColor(Color color) {
    final double luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white.withAlpha(230);
  }
  
  // Helper method to get inverse color
  static Color _getInverseColor(Color color) {
    final HSLColor hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness(1.0 - hsl.lightness)
        .toColor();
  }
}

// Example usage in your game
class GameTheme {
  static ThemeData getDarkTheme() {
    final ColorScheme colorScheme = GameColorScheme.fromSurface(const Color.fromARGB(255, 29, 4, 70));
    
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: Brightness.dark,
    );
  }
}