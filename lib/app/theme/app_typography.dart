import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String fontFamily = 'PlusJakartaSans';

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.17,
    letterSpacing: -1.0,
  );

  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 25,
    fontWeight: FontWeight.w700,
    height: 1.24,
    letterSpacing: -0.7,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    height: 1.32,
    letterSpacing: -0.4,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: -0.15,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const TextStyle tiny = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
}
