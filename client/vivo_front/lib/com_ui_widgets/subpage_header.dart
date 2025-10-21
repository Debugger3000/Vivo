import 'package:flutter/material.dart';
import 'package:vivo_front/theme/app_theme.dart'; // adjust import as needed

class SubPageHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const SubPageHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: false, // remove default back arrow    
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.of(context).pop(); // go back to previous page in navigator stack
        },
      ),
      title: Text(
        title
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
