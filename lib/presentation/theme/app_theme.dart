import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryPurple = Color(0xFF7B52F4);
  static const Color primaryPurpleDark = Color(0xFF3B1D8F);
  static const Color primaryPurpleLight = Color(0xFFE8E2FA);
  
  // Backgrounds
  static const Color scaffoldBackground = Color(0xFFF8F9FA);
  static const Color surfaceWhite = Colors.white;
  static const Color darkBackground = Color(0xFF13111C); // For the dark header

  // Text
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textGray = Color(0xFF8A8A8E);
  static const Color textLight = Colors.white;

  // Status
  static const Color successGreen = Color(0xFF34C759);
  static const Color errorRed = Color(0xFFFF3B30);

  // Gradients
  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF2C1E4A), Color(0xFF160F24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8C6BFA), Color(0xFF5B30F5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryPurple,
      scaffoldBackgroundColor: scaffoldBackground,
      fontFamily: 'Roboto', // Fallback, would be nice to use Inter/SF Pro
      appBarTheme: const AppBarTheme(
        backgroundColor: scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceWhite,
        selectedItemColor: primaryPurple,
        unselectedItemColor: textGray,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 20,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryPurple,
        secondary: primaryPurpleDark,
        surface: surfaceWhite,
        error: errorRed,
      ),
    );
  }
}
