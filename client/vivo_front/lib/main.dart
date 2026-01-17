import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vivo_front/pages/login_register/login.dart';
import 'package:vivo_front/pages/login_register/register.dart';
import 'package:vivo_front/pages/profile/profile.dart';
import 'package:vivo_front/theme/app_theme.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:vivo_front/navigation_wrapper.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:vivo_front/tester.dart';
// import 'package:vivo_front/api/google_map/google_map_wid.dart';

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

      initialRoute: '/navigation',
      // Root navigation
      routes: {
        '/register': (context) => const RegisterPage(),
        '/auth_gate': (context) => const AuthGate(),
        '/login': (context) => const LoginPage(),
        '/navigation': (context) => const NavigationWrapper(),
        '/profile': (context) => const ProfilePage(),
      },
      navigatorObservers: [routeObserver],
    );
  }
}

// AuthGate decides which page to show initially
// STATELESS 
// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});


//   // returning a widget here, instead of a Scaffold for Flutter widgets
//   @override
//   Widget build(BuildContext context) {
//     // see if a user session is logged in
//     final session = Supabase.instance.client.auth.currentSession;

//     // no user session found
//     if (session == null) {
//       Navigator.pushReplacementNamed(context, '/login');
//     }

//     // return app home
//     Navigator.pushReplacementNamed(context, '/navigation');
//   }
// }

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<String> _getInitialRoute() async {
    final session = Supabase.instance.client.auth.currentSession;
    return session == null ? '/login' : '/navigation';
  }

  @override
  Widget build(BuildContext context) {


    // FutureBuilder watches the Future you pass in.
    // It rebuilds its widget every time the state of the Future changes.
    return FutureBuilder<String>(
      future: _getInitialRoute(), // async function you provide
      builder: (context, snapshot) { //
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if(snapshot.hasError){
          print("Error on AuthGate Future");
        }

        // basically just a .then, / makes sure widget tree builds first, and then pushes a nav
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, snapshot.data!);
        });

        return const SizedBox(); // placeholder
      },
    );
  }
}
