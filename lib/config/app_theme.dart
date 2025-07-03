import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF6C5CE7);
  static const Color secondaryColor = Color(0xFF74B9FF);
  static const Color accentColor = Color(0xFFFD79A8);

  // Gradient Colors
  static const Color gradientStart = Color(0xFF6C5CE7);
  static const Color gradientEnd = Color(0xFF74B9FF);

  // Neutral Colors
  static const Color blackColor = Color(0xFF2D3436);
  static const Color darkGrey = Color(0xFF636E72);
  static const Color lightGrey = Color(0xFFDDD6FE);
  static const Color backgroundColor = Color(0xFFFAFBFC);
  static const Color whiteColor = Color(0xFFFFFFFF);

  // Status Colors
  static const Color successColor = Color(0xFF00B894);
  static const Color errorColor = Color(0xFFE17055);
  static const Color warningColor = Color(0xFFFDAB2A);
  static const Color infoColor = Color(0xFF74B9FF);

  // Food Category Colors
  static const Color foodPrimary = Color(0xFFFF6B6B);
  static const Color foodSecondary = Color(0xFFFFA726);
  static const Color foodAccent = Color(0xFF4ECDC4);

  // Common gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient foodGradient = LinearGradient(
    colors: [foodPrimary, foodSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Styles
  static TextStyle get headingLarge => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: blackColor,
  );

  static TextStyle get headingMedium => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: blackColor,
  );

  static TextStyle get headingSmall => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: blackColor,
  );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: blackColor,
  );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: blackColor,
  );

  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: darkGrey,
  );

  static TextStyle get buttonText => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: whiteColor,
  );

  static TextStyle get captionText => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: darkGrey,
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      headlineLarge: headingLarge,
      headlineMedium: headingMedium,
      headlineSmall: headingSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: buttonText,
    ),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: whiteColor,
    appBarTheme: AppBarTheme(
      backgroundColor: whiteColor,
      foregroundColor: blackColor,
      elevation: 0,
      titleTextStyle: headingMedium,
      iconTheme: const IconThemeData(color: blackColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: whiteColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: darkGrey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        textStyle: buttonText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 2),
        textStyle: buttonText.copyWith(color: primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: buttonText.copyWith(color: primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      filled: true,
      fillColor: whiteColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    cardTheme: CardThemeData(
      color: whiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    textTheme: TextTheme(
      headlineLarge: headingLarge.copyWith(color: whiteColor),
      headlineMedium: headingMedium.copyWith(color: whiteColor),
      headlineSmall: headingSmall.copyWith(color: whiteColor),
      bodyLarge: bodyLarge.copyWith(color: whiteColor),
      bodyMedium: bodyMedium.copyWith(color: whiteColor),
      bodySmall: bodySmall.copyWith(color: lightGrey),
      labelLarge: buttonText,
    ),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: blackColor,
    cardColor: const Color(0xFF2D3436),
    appBarTheme: AppBarTheme(
      backgroundColor: blackColor,
      foregroundColor: whiteColor,
      elevation: 0,
      titleTextStyle: headingMedium.copyWith(color: whiteColor),
      iconTheme: const IconThemeData(color: whiteColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF2D3436),
      selectedItemColor: primaryColor,
      unselectedItemColor: lightGrey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  // Common Decorations
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: whiteColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: blackColor.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get gradientDecoration => const BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  // Common Padding
  static const EdgeInsets screenPadding = EdgeInsets.all(16);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 24,
  );
}
