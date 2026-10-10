import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const Color espresso = Color(0xFF3B2922);
  static const Color espressoPressed = Color(0xFF291C17);
  static const Color espressoSoft = Color(0xFFF0EBE8);

  // Background and surfaces
  static const Color background = Color(0xFFF7F7F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFFAFAFA);
  static const Color surfaceMuted = Color(0xFFF1F1F1);

  // Typography
  static const Color textPrimary = Color(0xFF171717);
  static const Color textSecondary = Color(0xFF737373);
  static const Color textTertiary = Color(0xFF969696);

  // Interface
  static const Color border = Color(0xFFE8E8E8);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color icon = Color(0xFF525252);
  static const Color focus = espresso;

  // Semantic
  static const Color success = Color(0xFF60765B);
  static const Color warning = Color(0xFFC48A3D);
  static const Color error = Color(0xFFB42318);

  // Rating
  static const Color rating = Color(0xFFE8A23A);

  // Compatibility with existing pages
  static const Color cream = background;
  static const Color white = surface;
  static const Color charcoal = textPrimary;
  static const Color sage = success;
  static const Color latte = warning;
}
