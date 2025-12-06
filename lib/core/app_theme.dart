import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF1E463A);
  static const Color secondaryColor = Color(0xFFF7F4D9);
  static const Color backgroundColor = Color(0xFFF9F9F4);
  static const Color accentColor = Color(0xFFD4AF37);
  static const Color textColor = Color(0xFF333333);
  static const Color hintColor = Color(0xFF888888);
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textColor),
      titleTextStyle: TextStyle(
        color: AppColors.textColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textColor, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.textColor, fontSize: 14),
      titleLarge: TextStyle(
          color: AppColors.textColor, fontSize: 28, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          color: AppColors.textColor, fontSize: 22, fontWeight: FontWeight.bold),
      labelLarge: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.secondaryColor,
      hintStyle: const TextStyle(color: AppColors.hintColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      prefixIconColor: AppColors.hintColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.secondaryColor;
        }
        return Colors.grey.shade400;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.secondaryColor.withOpacity(0.5);
        }
        return Colors.grey.shade200;
      }),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primaryColor,
      secondary: AppColors.accentColor,
      background: AppColors.backgroundColor,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFDCE5D9),
    scaffoldBackgroundColor: const Color(0xFF2E5946),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFDCE5D9),
      hintStyle: TextStyle(color: Colors.grey.shade700),
      prefixIconColor: Colors.grey.shade700,
      suffixIconColor: Colors.grey.shade700,
      labelStyle: const TextStyle(color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFDCE5D9),
        foregroundColor: const Color(0xFF2E5946),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.secondaryColor;
        }
        return Colors.grey.shade400;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.secondaryColor.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      titleLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}
