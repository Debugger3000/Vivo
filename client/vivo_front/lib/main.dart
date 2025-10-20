import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vivo_front/pages/login_register/login.dart';
import 'package:vivo_front/pages/map/map.dart';
import 'package:vivo_front/theme/app_theme.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:vivo_front/navigation_wrapper.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:vivo_front/tester.dart';
import 'package:vivo_front/api/google_map/google_map_wid.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load(fileName: ".env");

  // Supabase initialization
  final supabaseUrl = dotenv.get('SUPABASE_URL');
  final supabaseKey = dotenv.get('SUPABASE_PUBLISHABLE_KEY');

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Vivo Front',
      theme: AppTheme.lightTheme,
      routes: {
        '/login': (context) => const LoginPage(),
        '/navigation': (context) => const NavigationWrapper(),
        '/map': (context) => const MapPage(), // New route for Google Map
      },
      navigatorObservers: [routeObserver],
      home: const AuthGate(),
    );
  }
}

// AuthGate decides which page to show initially
// STATELESS 
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      return const LoginPage();
    }

    return const NavigationWrapper();
  }
}
