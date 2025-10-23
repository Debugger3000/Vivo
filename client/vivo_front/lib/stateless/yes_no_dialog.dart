import 'package:flutter/material.dart';

/// A reusable Yes/No dialog.
class YesNoDialog extends StatelessWidget {
  final String title;
  final String yesText;
  final String noText;

  const YesNoDialog({
    super.key,
    required this.title,
    this.yesText = 'Yes',
    this.noText = 'No',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Return true for Yes
          },
          child: Text(yesText),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Return false for No
          },
          child: Text(noText),
        ),
      ],
    );
  }
}

/// Helper function to show the dialog and get the result
Future<bool?> showYesNoDialog(
  BuildContext context, {
  required String title,
  String yesText = 'Yes',
  String noText = 'No',
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => YesNoDialog(
      title: title,
      yesText: yesText,
      noText: noText,
    ),
  );
}
