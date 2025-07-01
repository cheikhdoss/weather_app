import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Couleurs personnalisées pour le thème clair
  static const Color _lightPrimary = Color(0xFF2193b0);
  static const Color _lightSecondary = Color(0xFF6dd5ed);
  static const Color _lightBackground = Color(0xFFF5F7FA);
  static const Color _lightSurface = Colors.white;
  static const Color _lightError = Color(0xFFDC3545);
  static const Color _lightTextPrimary = Color(0xFF2D3748);
  static const Color _lightTextSecondary = Color(0xFF718096);

  // Couleurs personnalisées pour le thème sombre
  static const Color _darkPrimary = Color(0xFF3699FF);
  static const Color _darkSecondary = Color(0xFF8950FC);
  static const Color _darkBackground = Color(0xFF1E1E2D);
  static const Color _darkSurface = Color(0xFF2B2B40);
  static const Color _darkError = Color(0xFFF64E60);
  static const Color _darkTextPrimary = Color(0xFFE5E5E5);
  static const Color _darkTextSecondary = Color(0xFFB5B5C3);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _lightPrimary,
    scaffoldBackgroundColor: _lightBackground,
    colorScheme: ColorScheme.light(
      primary: _lightPrimary,
      secondary: _lightSecondary,
      surface: _lightSurface,
      background: _lightBackground,
      error: _lightError,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: _lightTextPrimary,
      onBackground: _lightTextPrimary,
      onError: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: _lightSurface,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _lightSurface,
      elevation: 0,
      iconTheme: IconThemeData(color: _lightTextPrimary),
      titleTextStyle: GoogleFonts.montserrat(
        color: _lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: IconThemeData(
      color: _lightPrimary,
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.montserrat(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: _lightTextPrimary,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: _lightTextPrimary,
      ),
      titleLarge: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _lightTextPrimary,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontSize: 16,
        color: _lightTextPrimary,
      ),
      bodyMedium: GoogleFonts.montserrat(
        fontSize: 14,
        color: _lightTextSecondary,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: _lightPrimary,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _lightPrimary,
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _darkPrimary,
    scaffoldBackgroundColor: _darkBackground,
    colorScheme: ColorScheme.dark(
      primary: _darkPrimary,
      secondary: _darkSecondary,
      surface: _darkSurface,
      background: _darkBackground,
      error: _darkError,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: _darkTextPrimary,
      onBackground: _darkTextPrimary,
      onError: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: _darkSurface,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _darkSurface,
      elevation: 0,
      iconTheme: IconThemeData(color: _darkTextPrimary),
      titleTextStyle: GoogleFonts.montserrat(
        color: _darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: IconThemeData(
      color: _darkPrimary,
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.montserrat(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: _darkTextPrimary,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: _darkTextPrimary,
      ),
      titleLarge: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _darkTextPrimary,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontSize: 16,
        color: _darkTextPrimary,
      ),
      bodyMedium: GoogleFonts.montserrat(
        fontSize: 14,
        color: _darkTextSecondary,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: _darkPrimary,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _darkPrimary,
      foregroundColor: Colors.white,
    ),
  );
} 