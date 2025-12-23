import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vivo_front/api/api_service.dart';
import 'package:vivo_front/pages/events/CRUD/post_event.dart';
import 'package:vivo_front/com_ui_widgets/mainpage_header.dart';
import 'dart:developer' as developer;
import 'package:vivo_front/main.dart';

class ProfileTab extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ProfileTab({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/profile',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case '/profile':
            builder = (context) => const ProfilePage();
            break;
          case '/settings':
            builder = (context) => PostEventForm();
            break;
          default:
            builder = (context) => const ProfilePage();
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

// ---------------------------------------------

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with RouteAware {
  final ApiService api = ApiService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    developer.log("Returned to profile page", name: 'vivo-loggy');
  }

  // 🔐 Supabase logout
  Future<void> logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainPageHeader(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 54),

            // Profile image
            const CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage(
                'assets/images/profile.jpg', // replace if needed
              ),
            ),

            const SizedBox(height: 12),

            // Name (replace later with Supabase user data)
            const Text(
              'Chad Bosing',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),

            _ProfileItem(
              title: 'Profile',
              onTap: () {
                // push profile details later
              },
            ),
            _ProfileItem(
              title: 'Account',
              onTap: () {
                // push account page
              },
            ),
            _ProfileItem(
              title: 'Accessibility',
              onTap: () {
                // push accessibility page
              },
            ),

            const SizedBox(height: 8),

            // Logout
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () => logout(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------

class _ProfileItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _ProfileItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
