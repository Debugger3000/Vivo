import 'package:flutter/material.dart';


class BasicTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final int? maxLines; // optional: for multi-line support
  final int? maxLength; // optional: character limit
  final TextInputType? keyboardType; // optional: input type

  const BasicTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
    this.maxLines = 1, // default to single line
    this.maxLength,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // margin between fields
      child: TextFormField(
        controller: controller,
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType ?? (maxLines! > 1 ? TextInputType.multiline : TextInputType.text),
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
          alignLabelWithHint: maxLines! > 1, // label aligns at top for multi-line
        ),
      ),
    );
  }
}
