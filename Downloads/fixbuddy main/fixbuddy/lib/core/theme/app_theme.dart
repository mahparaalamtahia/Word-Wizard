import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF2F6BFF);
  static const Color primaryLight = Color(0xFFEAF1FF);
  static const Color primaryDeep = Color(0xFF1849C6);
  static const Color accent = Color(0xFF00B8D9);
  static const Color background = Color(0xFFF7F9FC);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color inputBg = Color(0xFFF1F5F9);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color confirmedBg = Color(0xFFE8F7EF);
  static const Color confirmedText = Color(0xFF0F9D58);
  static const Color pendingBg = Color(0xFFFFF5D7);
  static const Color pendingText = Color(0xFFB7791F);
  static const Color declinedBg = Color(0xFFFFE4E6);
  static const Color declinedText = Color(0xFFDC2626);
  static const Color completedBg = Color(0xFFE7F1FF);
  static const Color completedText = Color(0xFF2563EB);
  static const Color iconGreen = Color(0xFF10B981);
  static const Color iconRed = Color(0xFFEF4444);
  static const Color iconBlue = Color(0xFF2F6BFF);
  static const Color iconAmber = Color(0xFFF59E0B);
  static const Color navActive = Color(0xFF2F6BFF);
  static const Color navInactive = Color(0xFF94A3B8);
  static const Color navBorder = Color(0xFFE2E8F0);
  static const Color avatarBg = Color(0xFF5166E9);
  static const Color backgroundAlt = Color(0xFFEEF4FF);
  static const Color heroTop = Color(0xFF0F172A);
  static const Color heroBottom = Color(0xFF2448C3);

  static const Color secondary = primaryLight;
  static const Color foreground = textPrimary;
  static const Color muted = inputBg;
  static const Color mutedFg = textSecondary;
  static const Color border = borderColor;
  static const Color destructive = declinedText;
  static const Color success = confirmedText;
  static const Color warning = pendingText;
  static const Color chartPurple = Color(0xFF8B5CF6);
  static const double radius = 12.0;
  static const Color primaryColor = primary;
  static const Color secondaryColor = secondary;
  static const Color backgroundColor = background;
  static const Color errorColor = declinedText;
  static const Color softBlueTint = primaryLight;
  static const Color softBlueBorder = Color(0xFFDBEAFE);
  static const Color hintText = textMuted;
  static const Color surfaceMuted = inputBg;
  static const Color availabilityOn = confirmedText;
  static const Color statusPendingBg = pendingBg;
  static const Color statusPendingText = pendingText;
  static const Color statusConfirmedBg = confirmedBg;
  static const Color statusConfirmedText = confirmedText;
  static const Color statusDeclinedBg = declinedBg;
  static const Color statusDeclinedText = declinedText;
  static const Color statusCompletedBg = completedBg;
  static const Color statusCompletedText = completedText;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: primaryLight,
        error: declinedText,
        surface: surface,
        outline: borderColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 54),
          backgroundColor: primary,
          foregroundColor: background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 54),
          foregroundColor: textPrimary,
          side: const BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: borderColor),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: borderColor,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: navActive,
        unselectedItemColor: navInactive,
        type: BottomNavigationBarType.fixed,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryLight,
        selectedColor: primary,
        disabledColor: inputBg,
        labelStyle: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: const TextStyle(color: background),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
