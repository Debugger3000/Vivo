



// lib/app_theme.dart
import 'package:flutter/material.dart';
import 'app_styles.dart'; // Import your styles constants

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppStyles.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyMedium: AppStyles.bodyMedium,
      headlineMedium: AppStyles.headingMedium,
      // headline1: AppStyles.heading,
      // bodyText1: AppStyles.body,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppStyles.primaryColor,
      foregroundColor: Colors.white,
    ),
    // buttonTheme: const ButtonThemeData(
    //   buttonColor: AppStyles.secondaryColor,
    //   textTheme: ButtonTextTheme.primary,
    // ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 24, 103, 207), // default color
        foregroundColor: const Color.fromARGB(255, 247, 247, 247),      // text color
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

// ----------------------------------------
// THEME RULES
// 
//  1. Use "FilledButton" for general buttons
// 
//  2. 
