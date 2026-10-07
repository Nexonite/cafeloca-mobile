import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const Color espresso = Color(0xFF3B2922);

  // Base
  static const Color background = Color(0xFFF7F7F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFFAFAFA);

  // Text
  static const Color textPrimary = Color(0xFF171717);
  static const Color textSecondary = Color(0xFF737373);
  static const Color textTertiary = Color(0xFFA3A3A3);

  // UI
  static const Color border = Color(0xFFECECEC);
  static const Color divider = Color(0xFFF0F0F0);
  static const Color icon = Color(0xFF525252);

  // Semantic
  static const Color success = Color(0xFF70806A);
  static const Color warning = Color(0xFFD89A4A);
  static const Color error = Color(0xFFB42318);

  // Rating
  static const Color rating = Color(0xFFE8A23A);

  // Compatibility sementara
  static const Color cream = background;
  static const Color white = surface;
  static const Color charcoal = textPrimary;
  static const Color sage = success;
  static const Color latte = warning;
}
