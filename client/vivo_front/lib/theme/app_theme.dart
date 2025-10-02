



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
    buttonTheme: const ButtonThemeData(
      buttonColor: AppStyles.secondaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
