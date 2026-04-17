import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand palette — warm boba café
  static const Color pink = Color(0xFFFFD6E8);           // blush
  static const Color lightBlue = Color(0xFFC8E6F5);      // soft sky
  static const Color lightGreen = Color(0xFFD4EDD5);     // soft matcha
  static const Color lightYellow = Color(0xFFFFF3E0);    // warm peach
  static const Color warmGray = Color(0xFFF3F3F5);      // warm gray

  // Derived semantic colours
  static const Color scaffoldBackground = Color(0xFFFFFFFF); // warm cream
  static const Color cardBackground = Colors.white;
  static const Color primary = Color(0xFFE07A98);            // dusty rose
  static const Color primaryContainer = pink;
  static const Color secondary = Color(0xFF9B8B7A);          // boba taupe
  static const Color secondaryContainer = Color(0xFFEDE3DC); // light taupe
  static const Color success = Color(0xFF4CAF73);
  static const Color successContainer = lightGreen;
  static const Color error = Color(0xFFE53935);
  static const Color onPrimary = Colors.white;
  static const Color onSurface = Color(0xFF2D1117);          // deep warm brown
  static const Color onSurfaceVariant = Color(0xFF7A5B62);   // warm mauve
  static const Color divider = Color(0xFFF5E0E8);            // pink-tinted
  static const Color shadow = Color(0x18641428);             // warm pink shadow

  // Status colours
  static const Color pending = Color(0xFFFFA726);
  static const Color completed = Color(0xFF4CAF73);
  static const Color cancelled = Color(0xFFE53935);
}
