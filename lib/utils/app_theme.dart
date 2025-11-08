import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryLight = Color(0xFF262262);
  static const Color secondaryLight = Color(0xFF43A047);
  static const Color backgroundLight = Color(0xFFF8F9FA);

  static const Color primaryDark = Color(0xFF5C6BC0);
  static const Color secondaryDark = Color(0xFF66BB6A);
  static const Color backgroundDark = Color(0xFF121212);

  /// Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: backgroundLight,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryLight,
      primary: primaryLight,
      secondary: secondaryLight,
      brightness: Brightness.light,
    ),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: primaryLight,
      surfaceTintColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryLight,
      ),
      iconTheme: const IconThemeData(color: primaryLight),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),

    // Text Theme
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF262262),
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF262262),
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF262262),
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF262262),
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF262262),
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF424242)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF424242)),
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: primaryLight),

    // Divider Theme
    dividerTheme: DividerThemeData(color: Colors.grey[300], thickness: 1),
  );

  /// Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: backgroundDark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryDark,
      primary: primaryDark,
      secondary: secondaryDark,
      brightness: Brightness.dark,
      surface: const Color(0xFF1E1E1E),
    ),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF1E1E1E),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),

    // Text Theme
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFE0E0E0)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: primaryDark),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: Color(0xFF424242),
      thickness: 1,
    ),
  );
}
