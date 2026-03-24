



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
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppStyles.primaryColor, // AppBar background
      foregroundColor: Colors.white,           // default icon/text color
      elevation: 1,
      centerTitle: true,
      titleTextStyle: AppStyles.headingMedium.copyWith(
        color: const Color.fromARGB(255, 240, 240, 240), // AppBar title text color
      ),
      iconTheme: const IconThemeData(color: Colors.white), // leading icons
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
     bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.blue,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.7),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      type: BottomNavigationBarType.fixed, // ensures fixed style
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color.fromARGB(255, 255, 255, 255),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
         borderSide: const BorderSide(
              color: Color.fromARGB(255, 218, 218, 218), // light gray border
              width: 0.0, // thin border
            ),
      
      ),
      hintStyle: TextStyle(
        color: Colors.grey[600],
        fontWeight: FontWeight.w500,
      ),
      labelStyle: TextStyle(
        color: Colors.grey[800],
        fontWeight: FontWeight.w600,
      ),
    ),
     
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppStyles.primaryColor,
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: const TextTheme(
      bodyMedium: AppStyles.bodyMedium,
      headlineMedium: AppStyles.headingMedium,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      titleTextStyle: AppStyles.headingMedium.copyWith(
        color: const Color.fromARGB(255, 240, 240, 240),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 24, 103, 207),
        foregroundColor: const Color.fromARGB(255, 247, 247, 247),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.7),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 60, 60, 60),
          width: 0.0,
        ),
      ),
      hintStyle: TextStyle(
        color: Colors.grey[400],
        fontWeight: FontWeight.w500,
      ),
      labelStyle: TextStyle(
        color: Colors.grey[300],
        fontWeight: FontWeight.w600,
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
