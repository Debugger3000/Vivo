



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
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blue,
      currentIndex: _selectedIndex,
      onTap: _onTabTapped,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'List', 
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    ),
  );
}
}


// 
// Navigator.push(
//   context,
//   MaterialPageRoute(builder: (_) => const MapPage()),
// );
