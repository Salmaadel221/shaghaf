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

    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primaryColor,
      secondary: AppColors.accentColor,
      background: AppColors.backgroundColor,
    ),
  );
}
