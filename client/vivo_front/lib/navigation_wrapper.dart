



import 'package:flutter/material.dart';
import 'package:vivo_front/pages/map/map.dart';
import 'package:vivo_front/pages/profile/profile.dart';
import 'package:vivo_front/pages/events/events.dart';
// import './package:vivo_front/pages/profile_page.dart';

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int _selectedIndex = 1;

  // Optional: a key for the nested navigator in MapTab
  final GlobalKey<NavigatorState> _eventsNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _mapNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _profileNavKey = GlobalKey<NavigatorState>();

   final List<Widget> _tabs = [];

  // run on widget build
  @override
  void initState() {
    super.initState();
    _tabs.addAll([
      EventsTab(navigatorKey: _eventsNavKey),
      MapTab(navigatorKey: _mapNavKey), // <-- use MapTab here
      ProfileTab(navigatorKey: _profileNavKey),
    ]);
  }


  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: null,
    body: IndexedStack(
      index: _selectedIndex,
      children: _tabs,
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
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: isCenter ? 28 : 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
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


// 
// Navigator.push(
//   context,
//   MaterialPageRoute(builder: (_) => const MapPage()),
// );
