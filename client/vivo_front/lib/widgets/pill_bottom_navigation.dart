import 'package:flutter/material.dart';

class PillBottomNavigation extends StatefulWidget {
  const PillBottomNavigation({super.key, required int selectedIndex, required void Function(int index) onTabSelected});

  @override
  State<PillBottomNavigation> createState() => _PillBottomNavigationState();
}

class _PillBottomNavigationState extends State<PillBottomNavigation> {
  int selectedIndex = 1;
  
  int? get _selectedIndex => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: null,
    body: IndexedStack(
      index: _selectedIndex,
      //children: _tabs,
    ),
  bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                icon: Icons.square,
                label: 'List',
                index: 0,
              ),
              _navItem(
                icon: Icons.circle,
                label: 'Map',
                index: 1,
                isCenter: true,
              ),
              _navItem(
                icon: Icons.change_history,
                label: 'Profile',
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
    bool isCenter = false,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
         // _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: isCenter ? 28 : 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected && isCenter
              ? Colors.grey.shade200
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.blue : Colors.black,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.black,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}