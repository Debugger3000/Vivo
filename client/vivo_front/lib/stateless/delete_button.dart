import 'package:flutter/material.dart';
import 'dart:ui';

class DeleteButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const DeleteButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color.fromARGB(50, 200, 200, 200), // default light gray glass
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: const Color.fromARGB(248, 229, 234, 240),
          child: InkWell(
            onTap: onPressed,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.red, // iOS-style destructive
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
