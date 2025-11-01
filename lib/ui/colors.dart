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

  // Additional common colors for light theme
  static const whiteLight = Color(0xFFFFFFFF);
  static const blackLight = Color(0xFF000000);
  static const transparentLight = Color(0x00000000);
  static const greyLight = Color(0xFF9E9E9E);
  static const grey100Light = Color(0xFFF5F5F5);
  static const grey200Light = Color(0xFFEEEEEE);
  static const grey300Light = Color(0xFFE0E0E0);
  static const grey400Light = Color(0xFFBDBDBD);
  static const grey500Light = Color(0xFF9E9E9E);
  static const grey600Light = Color(0xFF757575);
  static const grey700Light = Color(0xFF616161);
  static const grey800Light = Color(0xFF424242);
  static const grey900Light = Color(0xFF212121);

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

  // Additional common colors for dark theme
  static const whiteDark = Color(0xFFE1E1E1);
  static const blackDark = Color(0xFF1A1A1A);
  static const transparentDark = Color(0x00000000);
  static const greyDark = Color(0xFF757575);
  static const grey100Dark = Color(0xFF424242);
  static const grey200Dark = Color(0xFF616161);
  static const grey300Dark = Color(0xFF757575);
  static const grey400Dark = Color(0xFF9E9E9E);
  static const grey500Dark = Color(0xFFBDBDBD);
  static const grey600Dark = Color(0xFFE0E0E0);
  static const grey700Dark = Color(0xFFEEEEEE);
  static const grey800Dark = Color(0xFFF5F5F5);
  static const grey900Dark = Color(0xFFFFFFFF);

  // Context-aware getters for theme-based colors
  static Color white(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? whiteDark
        : whiteLight;
  }

  static Color black(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? blackDark
        : blackLight;
  }

  static Color transparent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? transparentDark
        : transparentLight;
  }

  static Color grey(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? greyDark
        : greyLight;
  }

  static Color grey100(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? grey100Dark
        : grey100Light;
  }

  static Color grey200(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? grey200Dark
        : grey200Light;
  }

  static Color grey300(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? grey300Dark
        : grey300Light;
  }

  static Color grey400(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? grey400Dark
        : grey400Light;
  }

  static Color grey500(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? grey500Dark
        : grey500Light;
  }

  static Color grey600(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? grey600Dark
        : grey600Light;
  }

  static Color grey700(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? grey700Dark
        : grey700Light;
  }

  static Color grey800(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? grey800Dark
        : grey800Light;
  }

  static Color grey900(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? grey900Dark
        : grey900Light;
  }

  // Additional convenience methods for common color needs
  static Color primary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? primaryDark
        : primaryLight;
  }

  static Color secondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? secondaryDark
        : secondaryLight;
  }

  static Color surface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? surfaceDark
        : surfaceLight;
  }

  static Color onSurface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? onSurfaceDark
        : onSurfaceLight;
  }

  static Color card(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? cardDark
        : cardLight;
  }

  static Color green(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? successDark
        : successLight;
  }

  static Color red(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? errorDark
        : errorLight;
  }

  static Color hexToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // Adds the opacity if not provided.
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
