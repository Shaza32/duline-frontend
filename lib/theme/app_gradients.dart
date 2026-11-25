import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._();

  static const LinearGradient gold = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFE8A3),
      Color(0xFFFFD36A),
      Color(0xFFE9AA35),
      Color(0xFFB97819),
    ],
    stops: [0.0, 0.35, 0.70, 1.0],
  );

  static const LinearGradient darkSurface = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF252525),
      Color(0xFF141414),
      Color(0xFF080808),
    ],
  );

  static const LinearGradient goldBorder = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFE5A0),
      Color(0xFFB97819),
      Color(0xFFFFD36A),
    ],
  );
}