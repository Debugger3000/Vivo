


import 'package:flutter/material.dart';

class AppStyles {
  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.orange;

  // Padding
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets smallPadding = EdgeInsets.symmetric(horizontal: 8.0);

  // Text Styles
  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 37, 37, 37),
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );
}
