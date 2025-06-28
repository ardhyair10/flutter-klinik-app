// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //==========================================================================
  // TEMA FUTURISTIK (DARK MODE)
  //==========================================================================
  // Bagian ini sudah benar, tidak ada perubahan.
  static const Color _darkBgColor = Color(0xFF1A1A2E);
  static const Color _darkCardColor = Color(0xFF16213E);
  static const Color _primaryAccentColor = Color(0xFF00F5FF);
  static const Color _errorColor = Color(0xFFF9385E);

  static final ThemeData darkFuturisticTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _primaryAccentColor,
    scaffoldBackgroundColor: _darkBgColor,
    fontFamily: GoogleFonts.exo2().fontFamily,
    colorScheme: ColorScheme.dark(
      primary: _primaryAccentColor,
      secondary: _primaryAccentColor,
      background: _darkBgColor,
      surface: _darkCardColor,
      error: _errorColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _darkBgColor,
      elevation: 4,
      shadowColor: _primaryAccentColor.withOpacity(0.2),
      titleTextStyle: GoogleFonts.orbitron(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: _primaryAccentColor,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryAccentColor,
      foregroundColor: _darkBgColor,
    ),
    textTheme: TextTheme(
      displaySmall: GoogleFonts.orbitron(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.exo2(
        fontSize: 18,
        color: Colors.white.withOpacity(0.85),
      ),
      titleLarge: GoogleFonts.orbitron(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: GoogleFonts.exo2(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.exo2(
        fontSize: 14,
        color: Colors.white.withOpacity(0.75),
      ),
      labelSmall: GoogleFonts.exo2(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white.withOpacity(0.9),
      ),
      headlineSmall: GoogleFonts.orbitron(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodySmall: GoogleFonts.exo2(
        fontSize: 14,
        color: Colors.white.withOpacity(0.75),
      ),
    ),
    cardTheme: CardTheme(
      color: _darkCardColor,
      elevation: 4,
      shadowColor: _primaryAccentColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _primaryAccentColor.withOpacity(0.3), width: 1),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: _darkCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titleTextStyle: GoogleFonts.orbitron(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _primaryAccentColor,
      ),
      contentTextStyle: GoogleFonts.exo2(
        fontSize: 16,
        color: Colors.white.withOpacity(0.8),
      ),
    ),
    iconTheme: IconThemeData(color: _primaryAccentColor.withOpacity(0.8)),
  );

  //==========================================================================
  // TEMA CERAH (LIGHT MODE) - DENGAN PERBAIKAN
  //==========================================================================
  static const _primaryColorLight = Colors.teal;
  static const _errorColorLight = Colors.red;

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: _primaryColorLight,
    scaffoldBackgroundColor: Colors.grey[50],
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: _primaryColorLight,
      brightness: Brightness.light,
    ).copyWith(error: _errorColorLight),
    appBarTheme: AppBarTheme(
      backgroundColor: _primaryColorLight,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColorLight,
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      displaySmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 18,
        color: Colors.grey[700],
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
      labelSmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black.withOpacity(0.8),
      ),

      // === PERBAIKAN DI SINI ===
      // Mengubah warna teks header agar terlihat di latar belakang terang.
      headlineSmall: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodySmall: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      contentTextStyle: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.black87,
      ),
    ),
  );
}
