
import 'package:flutter/material.dart';

extension A on ColorScheme {
  ColorScheme fromSurface(Color surfaceColor) {
    
   final HSLColor surfaceHsl = HSLColor.fromColor(surfaceColor);
        
    Color primaryInterpolatingColor = brightness == Brightness.dark 
                                      ? Colors.white : Colors.black; 
    Color secondaryInterpolatingColor = brightness == Brightness.dark 
                                      ? Colors.yellow.shade100 : const Color.fromARGB(255, 14, 10, 63);                                   
    Color tertiaryInterpolatingColor = brightness == Brightness.dark 
                                      ? Colors.green.shade50 : const Color.fromARGB(255, 6, 59, 13);                                   

    
    final Color primary = Color.lerp(surfaceColor, primaryInterpolatingColor, 0.8)!;

    final Color secondary = Color.lerp(surfaceColor, secondaryInterpolatingColor, 0.8)!;
    
    final Color tertiary = Color.lerp(surfaceColor, tertiaryInterpolatingColor, 0.8)!;
    
    // Create error color (reddish, but harmonious with surface)
    final Color error = surfaceHsl
        .withHue(0)
        .withSaturation(0.8)
        .withLightness(0.5)
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

    
    return  ColorScheme(
      brightness: brightness,
      // Primary colors
      primary: primary,
      onPrimary: _getContrastingColor(primary),
      primaryContainer: primary.withValues(alpha: 0.3),
      onPrimaryContainer: _getContrastingColor(primary.withValues(alpha: 0.3)),
      
      // Secondary colors
      secondary: secondary,
      onSecondary: _getContrastingColor(secondary),
      secondaryContainer: secondary.withValues(alpha: 0.3),
      onSecondaryContainer: _getContrastingColor(secondary.withValues(alpha: 0.3)),
      
      // Tertiary colors
      tertiary: tertiary,
      onTertiary: _getContrastingColor(tertiary),
      tertiaryContainer: tertiary.withValues(alpha: 0.3),
      onTertiaryContainer: _getContrastingColor(tertiary.withValues(alpha: 0.3)),
      
      // Error colors
      error: error,
      onError: _getContrastingColor(error),
      errorContainer: error.withValues(alpha: 0.3),
      onErrorContainer: _getContrastingColor(error.withValues(alpha: 0.3)),
      
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