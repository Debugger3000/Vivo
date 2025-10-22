import 'package:flutter/material.dart';


// Basic header for BACK + TITLE on subpages
// 
class MainPageHeader extends StatelessWidget implements PreferredSizeWidget {

  const MainPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // remove default back arrow    
      leading: Icon((Icons.map_sharp)
      ),
      title: Text(
        "Vivo"
      ),
      centerTitle: false,
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
