import 'package:flutter/material.dart';


// Basic header for BACK + TITLE on subpages
// 
class SubPageHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const SubPageHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
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
