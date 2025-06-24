import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData theme = ThemeData(
    primaryColor: const Color(0xFFD50631),
    scaffoldBackgroundColor: const Color(0xFFD50631),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD50631),
      secondary: Colors.yellow,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFD50631),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
