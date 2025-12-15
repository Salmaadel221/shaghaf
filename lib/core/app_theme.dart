import 'package:flutter/material.dart';

class AppThemes {
  // ===============================
  // 🌙 DARK THEME
  // ===============================
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF5C7363),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff5C7363),
      foregroundColor: Color(0xffF0E99A),
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xff1D4036)),
      bodyMedium: TextStyle(color: Color(0xffF2F0D9)),
      titleLarge: TextStyle(color: Color(0xffF0E99A)),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff1D4036), // Text & icons
      secondary: Color(0xff1D4036), // Buttons
      surface: Color(0xffF2F0D9), // Containers
      onSurface: Color(0xffF0E99A),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff1D4036),
        foregroundColor: const Color(0xffF0E99A),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xffF2B90C),
      selectedItemColor: Color(0xff1D4036),
      unselectedItemColor: Color(0xffF0E99A),
    ),
    cardColor: const Color(0xffF2B90C),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xffF2F0D9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    canvasColor: const Color(0xffF2F0D9), // Settings containers
  );

  // ===============================
  // ☀️ LIGHT THEME
  // ===============================
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xffF2F0D9),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffF2F0D9),
      foregroundColor: Color(0xff1D4036),
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xff1D4036) , fontSize: 20 , fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Color(0xff1D4036)),
      titleLarge: TextStyle(color: Color(0xffF0E99A)),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xff1D4036), // Text & icons
      secondary: Color(0xff1D4036), // Buttons
      surface: Color(0xffF2F0D9), // Containers
      onSurface: Color(0xff1D4036),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff1D4036),
        foregroundColor: const Color(0xffF0E99A),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xffF2cf1d),
      selectedItemColor: Color(0xff1D4036),
      unselectedItemColor: Color(0xff1D4036),
    ),
    cardColor: const Color(0xffF2cf1d),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xffF2cf1d),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    canvasColor: const Color(0xffF0E99A), // Settings containers
  );
}
