import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Main colors
  static const Color background = Color(0xFF0A0A19);
  static const Color backgroundDarker = Color(0xFF050510);
  static const Color backgroundLighter = Color(0xFF121225);
  static const Color primaryNeon = Color(0xFF00E6C3); // Teal
  static const Color secondaryNeon = Color(0xFF7B42F6); // Purple
  static const Color accentNeon = Color(0xFF00B6FF); // Electric blue
  static const Color dangerNeon = Color(0xFFFF2D55); // Neon red
  static const Color warningNeon = Color(0xFFFFD60A); // Neon yellow
  static const Color surfaceColor = Color(0xFF1A1A2E);
  
  // Text colors
  static const Color textPrimary = Color(0xFFF2F2FF);
  static const Color textSecondary = Color(0xFFB3B3CC);
  static const Color textMuted = Color(0xFF6E6E8F);
  
  // Card & Border colors
  static const Color cardDark = Color(0xFF15152A);
  static const Color cardLight = Color(0xFF202040);
  static const Color borderDark = Color(0xFF232342);
  static const Color borderLight = Color(0xFF2A2A52);
  
  // Glassmorphism opacity levels
  static const double glassOpacityHigh = 0.15;
  static const double glassOpacityMedium = 0.1;
  static const double glassOpacityLow = 0.05;
  
  // Neumorphism shadow configuration
  static const double neumorphDepth = 5.0;
  static final Color neumorphLightShadow = Colors.white.withOpacity(0.05);
  static final Color neumorphDarkShadow = Colors.black.withOpacity(0.5);
  
  // Blurs
  static const double blurStrong = 20.0;
  static const double blurMedium = 10.0;
  static const double blurLight = 5.0;
  
  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusExtraLarge = 36.0;
  static const double radiusRounded = 100.0;
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Animation Durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 400);
  static const Duration animSlow = Duration(milliseconds: 800);

  // ThemeData
  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: primaryNeon,
      colorScheme: const ColorScheme.dark(
        primary: primaryNeon,
        secondary: secondaryNeon,
        background: background,
        surface: surfaceColor,
        error: dangerNeon,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: textPrimary,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            color: textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          displaySmall: TextStyle(
            color: textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: textSecondary,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: textSecondary,
            fontSize: 14,
          ),
          bodySmall: TextStyle(
            color: textMuted,
            fontSize: 12,
          ),
        ),
      ),
      cardTheme: const CardTheme(
        elevation: 0,
        color: cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusMedium)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundDarker,
        selectedItemColor: primaryNeon,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: backgroundLighter,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radiusLarge),
            topRight: Radius.circular(radiusLarge),
          ),
        ),
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: backgroundLighter,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusLarge)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderDark,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primaryNeon, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: dangerNeon),
        ),
        hintStyle: const TextStyle(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          backgroundColor: primaryNeon,
          foregroundColor: backgroundDarker,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryNeon,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          side: const BorderSide(color: primaryNeon),
          foregroundColor: primaryNeon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
} 