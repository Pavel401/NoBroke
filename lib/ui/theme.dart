import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _loadTheme();
  }

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void toggleTheme() async {
    setDarkMode(!isDarkMode);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  void _loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDarkMode = prefs.getBool('isDarkMode');
    if (isDarkMode == null) {
      final Brightness brightness =
          WidgetsBinding.instance.window.platformBrightness;
      isDarkMode = brightness == Brightness.dark;
    }
    setDarkMode(isDarkMode);
  }

  ThemeData get currentTheme {
    return isDarkMode ? darkTheme : lightTheme;
  }

  // Light Theme with enhanced colors and animations
  final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    textTheme: textTheme,
    colorScheme: const ColorScheme.light(
      primary: TurfitColors.primaryLight,
      secondary: TurfitColors.secondaryLight,
      tertiary: TurfitColors.tertiaryLight,
      onPrimary: TurfitColors.onPrimaryLight,
      surface: TurfitColors.surfaceLight,
      onSurface: TurfitColors.onSurfaceLight,
      outline: TurfitColors.outlineLight,
      error: TurfitColors.errorLight,
    ),
    scaffoldBackgroundColor: TurfitColors.surfaceLight,
    appBarTheme: AppBarTheme(
      backgroundColor: TurfitColors.surfaceLight,
      foregroundColor: TurfitColors.onSurfaceLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: TurfitColors.onSurfaceLight,
      ),
    ),
    cardTheme: CardThemeData(
      color: TurfitColors.cardLight,
      surfaceTintColor: TurfitColors.primaryLight,
      elevation: 4,
      shadowColor: TurfitColors.primaryLight.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: TurfitColors.surfaceLight,
      surfaceTintColor: TurfitColors.primaryLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: textTheme.titleLarge!.copyWith(
        color: TurfitColors.onSurfaceLight,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: textTheme.bodyMedium!.copyWith(
        color: TurfitColors.onSurfaceLight,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: textTheme.bodyLarge,
      border: const OutlineInputBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return TurfitColors.outlineLight;
          }
          return TurfitColors.primaryLight;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          return TurfitColors.onPrimaryLight;
        }),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        elevation: WidgetStateProperty.all(4),
        shadowColor: WidgetStateProperty.all(
          TurfitColors.primaryLight.withOpacity(0.3),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      titleTextStyle: textTheme.bodyLarge!.copyWith(
        color: TurfitColors.onPrimaryLight,
      ),
      iconColor: TurfitColors.onPrimaryLight,
    ),
    // Enhanced Bottom Navigation Bar for kids
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: TurfitColors.transparentLight,
      elevation: 0,
      selectedItemColor: TurfitColors.primaryLight,
      unselectedItemColor: TurfitColors.grey500Light,
      selectedLabelStyle: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: GoogleFonts.nunito(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      type: BottomNavigationBarType.fixed,
    ),
    // Enhanced FloatingActionButton
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: TurfitColors.accentLight,
      foregroundColor: TurfitColors.whiteLight,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // Dark Theme with enhanced colors and animations
  final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    textTheme: textTheme,
    colorScheme: const ColorScheme.dark(
      primary: TurfitColors.primaryDark,
      secondary: TurfitColors.secondaryDark,
      tertiary: TurfitColors.tertiaryDark,
      onPrimary: TurfitColors.onPrimaryDark,
      surface: TurfitColors.surfaceDark,
      onSurface: TurfitColors.onSurfaceDark,
      outline: TurfitColors.outlineDark,
      error: TurfitColors.errorDark,
    ),
    scaffoldBackgroundColor: TurfitColors.surfaceDark,
    appBarTheme: AppBarTheme(
      backgroundColor: TurfitColors.surfaceDark,
      foregroundColor: TurfitColors.onSurfaceDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: TurfitColors.onSurfaceDark,
      ),
    ),
    cardTheme: CardThemeData(
      color: TurfitColors.cardDark,
      surfaceTintColor: TurfitColors.primaryDark,
      elevation: 4,
      shadowColor: TurfitColors.primaryDark.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: TurfitColors.surfaceDark,
      surfaceTintColor: TurfitColors.primaryDark,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: textTheme.titleLarge!.copyWith(
        color: TurfitColors.onSurfaceDark,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: textTheme.bodyMedium!.copyWith(
        color: TurfitColors.onSurfaceDark,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: textTheme.bodyLarge,
      border: const OutlineInputBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return TurfitColors.outlineDark;
          }
          return TurfitColors.primaryDark;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          return TurfitColors.onPrimaryDark;
        }),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        elevation: WidgetStateProperty.all(4),
        shadowColor: WidgetStateProperty.all(
          TurfitColors.primaryDark.withOpacity(0.3),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      titleTextStyle: textTheme.bodyLarge!.copyWith(
        color: TurfitColors.onPrimaryDark,
      ),
      iconColor: TurfitColors.onPrimaryDark,
    ),
    // Enhanced Bottom Navigation Bar for kids (Dark mode)
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: TurfitColors.transparentDark,
      elevation: 0,
      selectedItemColor: TurfitColors.primaryDark,
      unselectedItemColor: TurfitColors.grey400Dark,
      selectedLabelStyle: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: GoogleFonts.nunito(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      type: BottomNavigationBarType.fixed,
    ),
    // Enhanced FloatingActionButton (Dark mode)
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: TurfitColors.accentDark,
      foregroundColor: TurfitColors.onPrimaryDark,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

// Enhanced TextTheme with Nunito font for kid-friendly appeal
final TextTheme textTheme = TextTheme(
  displayLarge: GoogleFonts.nunito(
    fontSize: 57,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.25,
  ),
  displayMedium: GoogleFonts.nunito(
    fontSize: 45,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  ),
  displaySmall: GoogleFonts.nunito(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  ),
  headlineLarge: GoogleFonts.nunito(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  ),
  headlineMedium: GoogleFonts.nunito(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  ),
  headlineSmall: GoogleFonts.nunito(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  ),
  titleLarge: GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  ),
  titleMedium: GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  ),
  titleSmall: GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  ),
  labelLarge: GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  ),
  labelMedium: GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  ),
  labelSmall: GoogleFonts.nunito(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
  ),
  bodyLarge: GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  ),
  bodyMedium: GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
  ),
  bodySmall: GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
  ),
);
