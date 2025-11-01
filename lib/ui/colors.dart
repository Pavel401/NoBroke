import 'package:flutter/material.dart';

class TurfitColors {
  // Kid-friendly bright and engaging colors
  static const primaryLight = Color(0xFF6C63FF); // Vibrant purple
  static const secondaryLight = Color(0xFFFF6B6B); // Coral red
  static const tertiaryLight = Color(0xFF4ECDC4); // Turquoise
  static const accentLight = Color(0xFFFFD93D); // Bright yellow
  static const successLight = Color(0xFF6BCF7F); // Green
  static const onPrimaryLight = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFFFFFF8); // Warm white
  static const onSurfaceLight = Color(0xFF2D3436);
  static const outlineLight = Color(0xFFDDD6FE); // Light purple
  //Custom light theme colors
  static const searchBarLight = Color(0xFFF8F6FF); // Very light purple
  static const errorLight = Color(0xFFFF5757); // Bright red
  static const cardLight = Color(0xFFFFFFFF);
  static const gradientStart = Color(0xFF6C63FF);
  static const gradientEnd = Color(0xFF9C88FF);

  static const primaryDark = Color(0xFF9C88FF); // Lighter purple for dark mode
  static const secondaryDark = Color(0xFFFF8A8A); // Light coral
  static const tertiaryDark = Color(0xFF7FDEDC); // Light turquoise
  static const accentDark = Color(0xFFFFF176); // Light yellow
  static const successDark = Color(0xFF8FD899); // Light green
  static const onPrimaryDark = Color(0xFF1A1A1A);
  static const surfaceDark = Color(0xFF1A1A1A); // Dark surface
  static const onSurfaceDark = Color(0xFFE1E1E1);
  static const outlineDark = Color(0xFF4C4C6D);
  //Custom dark theme colors
  static const searchBarDark = Color(0xFF2A2A3E);
  static const errorDark = Color(0xFFFF6B6B);
  static const cardDark = Color(0xFF242438);
  static const gradientStartDark = Color(0xFF9C88FF);
  static const gradientEndDark = Color(0xFF6C63FF);

  static Color hexToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // Adds the opacity if not provided.
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
