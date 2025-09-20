import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MathChampTheme {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF1976D2), // Blue 700
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF1976D2),    // AppBar, buttons
      secondary: const Color(0xFFFFB300),  // Highlights / FAB
      surface: Colors.white,                // Cards / containers
      error: const Color(0xFFD32F2F),      // Wrong answer
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black87,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    appBarTheme:  AppBarTheme(
      backgroundColor: Color(0xFF1976D2),
      foregroundColor: Colors.white,
      elevation: 4,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFFB300),
      foregroundColor: Colors.black,
    ),
    textTheme:  TextTheme(
      headlineMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineSmall:  GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.black,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold
      ),
      labelMedium: GoogleFonts.baloo2(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: Colors.black12,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF90CAF9), // Light Blue
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF90CAF9),
      secondary: const Color(0xFFFFD54F),
      background: const Color(0xFF121212),
      surface: const Color(0xFF1E1E1E),
      error: const Color(0xFFEF5350),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white70,
      onError: Colors.black,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1976D2),
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFFD54F),
      foregroundColor: Colors.black,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
      headlineMedium: TextStyle(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF90CAF9),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      shadowColor: Colors.black45,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  // Correct / Wrong Answer Colors
  static const Color correctAnswer = Color(0xFF4CAF50); // Green 500
  static const Color wrongAnswer = Color(0xFFD32F2F);   // Red 700
  static const Color timerWarning = Color(0xFFFF9800);  // Orange 500
}
