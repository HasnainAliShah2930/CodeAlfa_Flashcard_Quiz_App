import 'package:flutter/material.dart';

/// Centralized color palette for the Flashcard Quiz app.
///
/// Keeping every color in one place means screens never hardcode raw
/// [Color] values, which makes re-theming trivial later on.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6C5DD3);
  static const Color primaryDark = Color(0xFF5B4BC4);
  static const Color primaryLight = Color(0xFF8B7FE8);

  static const Color background = Color(0xFFF7F7FB);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1E1E2D);
  static const Color textSecondary = Color(0xFF8A8AA3);

  static const Color border = Color(0xFFE7E7F2);

  static const Color success = Color(0xFF2ECC71);
  static const Color danger = Color(0xFFE65A5A);
  static const Color warning = Color(0xFFF5A623);

  static const Color statBlueBg = Color(0xFFEDEBFB);
  static const Color statGreenBg = Color(0xFFE3F8EC);
  static const Color statOrangeBg = Color(0xFFFDEFE2);

  // Dark Mode Colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color borderDark = Color(0xFF2C2C2E);
  static const Color textPrimaryDark = Color(0xFFF2F2F7);
  static const Color textSecondaryDark = Color(0xFF8E8E93);
}
