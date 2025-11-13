import 'package:flutter/material.dart';

class AppTheme {
  static final Color _seed = const Color(0xFF6750A4);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: Brightness.light,
      ).surface,
      foregroundColor: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: Brightness.light,
      ).onSurface,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 2,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: Brightness.dark,
      ).surface,
      foregroundColor: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: Brightness.dark,
      ).onSurface,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 2,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
