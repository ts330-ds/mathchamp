import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MathChampTheme {
  // Fun, vibrant colors for kids (4-16 years)
  static const Color funPurple = Color(0xFF9C27B0);
  static const Color funOrange = Color(0xFFFF9800);
  static const Color funPink = Color(0xFFE91E63);
  static const Color funTeal = Color(0xFF00BCD4);
  static const Color funGreen = Color(0xFF4CAF50);
  static const Color funYellow = Color(0xFFFFEB3B);
  static const Color funBlue = Color(0xFF2196F3);
  static const Color funRed = Color(0xFFF44336);

  // Gradient colors for backgrounds
  static const List<Color> rainbowGradient = [
    Color(0xFFFF6B6B),
    Color(0xFFFFE66D),
    Color(0xFF4ECDC4),
    Color(0xFF45B7D1),
    Color(0xFF96CEB4),
  ];

  static const List<Color> sunsetGradient = [
    Color(0xFFFF6B6B),
    Color(0xFFFFE66D),
    Color(0xFFFF9F43),
  ];

  static const List<Color> oceanGradient = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFF66a6ff),
  ];

  // Light Theme - Bright and Playful for Kids
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF6C63FF), // Playful purple-blue
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF6C63FF),    // Main purple-blue
      secondary: const Color(0xFFFFD93D),  // Bright yellow
      tertiary: const Color(0xFF6BCB77),   // Fun green
      surface: Colors.white,
      error: const Color(0xFFFF6B6B),       // Soft red
      onPrimary: Colors.white,
      onSecondary: Colors.black87,
      onSurface: const Color(0xFF2D3436),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF6C63FF),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.fredoka(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFFD93D),
      foregroundColor: Colors.black87,
      elevation: 8,
    ),
    textTheme: TextTheme(
      // Main headings - fun and bold
      displayLarge: GoogleFonts.fredoka(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2D3436),
      ),
      displayMedium: GoogleFonts.fredoka(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2D3436),
      ),
      // Section headings
      headlineLarge: GoogleFonts.fredoka(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2D3436),
      ),
      headlineMedium: GoogleFonts.fredoka(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2D3436),
      ),
      headlineSmall: GoogleFonts.fredoka(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      // Body text
      bodyLarge: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF2D3436),
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 16,
        color: const Color(0xFF2D3436),
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 14,
        color: const Color(0xFF636E72),
      ),
      // Labels for buttons
      labelLarge: GoogleFonts.fredoka(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      labelMedium: GoogleFonts.fredoka(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2D3436),
      ),
      labelSmall: GoogleFonts.fredoka(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF2D3436),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 6,
        shadowColor: const Color(0xFF6C63FF).withOpacity(0.4),
        textStyle: GoogleFonts.fredoka(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: Colors.black12,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.white,
    ),
  );

  // Dark Theme - Cosmic Space Theme for Kids
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF7C4DFF),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF7C4DFF),
      secondary: const Color(0xFFFFD54F),
      tertiary: const Color(0xFF69F0AE),
      surface: const Color(0xFF1E1E2E),
      error: const Color(0xFFFF6B6B),
      onPrimary: Colors.white,
      onSecondary: Colors.black87,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF7C4DFF),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.fredoka(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFFD54F),
      foregroundColor: Colors.black87,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.fredoka(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: GoogleFonts.fredoka(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineLarge: GoogleFonts.fredoka(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.fredoka(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: GoogleFonts.fredoka(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 16,
        color: Colors.white70,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 14,
        color: Colors.white60,
      ),
      labelLarge: GoogleFonts.fredoka(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      labelMedium: GoogleFonts.fredoka(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      labelSmall: GoogleFonts.fredoka(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7C4DFF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 6,
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E2E),
      shadowColor: Colors.black45,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: const Color(0xFF1E1E2E),
    ),
  );

  // Correct / Wrong Answer Colors - More vibrant for kids
  static const Color correctAnswer = Color(0xFF6BCB77);
  static const Color wrongAnswer = Color(0xFFFF6B6B);
  static const Color timerWarning = Color(0xFFFFD93D);

  // Fun quiz card colors for different difficulty levels
  static const List<Color> quizCardColors = [
    Color(0xFFFFB3BA), // Light pink
    Color(0xFFBAE1FF), // Light blue
    Color(0xFFBAFFBA), // Light green
    Color(0xFFFFDFBA), // Light orange
    Color(0xFFE2BAFF), // Light purple
    Color(0xFFFFFFBA), // Light yellow
    Color(0xFFBAFFF7), // Light cyan
    Color(0xFFFFBAE4), // Light magenta
  ];

  // Age group colors
  static const Color ageGroup4to6 = Color(0xFFFF6B6B);   // Red - Beginner
  static const Color ageGroup7to9 = Color(0xFFFFD93D);   // Yellow - Easy
  static const Color ageGroup10to12 = Color(0xFF6BCB77); // Green - Medium
  static const Color ageGroup13to16 = Color(0xFF6C63FF); // Purple - Advanced

  // Get color based on age group
  static Color getAgeGroupColor(String ageGroup) {
    switch (ageGroup) {
      case '4-6':
        return ageGroup4to6;
      case '7-9':
        return ageGroup7to9;
      case '10-12':
        return ageGroup10to12;
      case '13-16':
        return ageGroup13to16;
      default:
        return ageGroup7to9;
    }
  }
}
