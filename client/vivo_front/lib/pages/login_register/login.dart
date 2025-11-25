// lib/screens/login.dart
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:vivo_front/navigation_wrapper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const _mobileRedirect = 'com.example.vivo_front://login-callback';

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _wireDeepLinks();
    _listenAuthChanges();
  }

  void _listenAuthChanges() {
    Supabase.instance.client.auth.onAuthStateChange.listen((e) {
      if (e.event == AuthChangeEvent.signedIn && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NavigationWrapper()),
        );
      }
    });
  }

  Future<void> _wireDeepLinks() async {
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) await _handleAuthLink(initial);
    } catch (_) {}
    _sub = _appLinks.uriLinkStream.listen((uri) async {
      await _handleAuthLink(uri);
    });
  }

  Future<void> _handleAuthLink(Uri uri) async {
    if (uri.scheme != 'com.example.vivo_front' || uri.host != 'login-callback') return;
    try {
      setState(() => isLoading = true);
      await Supabase.instance.client.auth.exchangeCodeForSession(uri.toString());
      // onAuthStateChange will navigate upon signedIn
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not complete sign-in')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Vivo')),
    body: Center(
      child: SizedBox(
        width: 400,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 24), // space under AppBar
                Opacity(
                  opacity: isLoading ? 0.5 : 1,
                  child: AbsorbPointer(
                    absorbing: isLoading,
                    child: SupaEmailAuth(
                      redirectTo: kIsWeb ? null : _mobileRedirect,
                      onSignUpComplete: (response) async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Check your email to confirm your account.')),
                        );
                      },
                      onSignInComplete: (response) async {
                        // rely on onAuthStateChange
                      },
                      metadataFields: [
                        MetaDataField(
                          prefixIcon: const Icon(Icons.person),
                          label: 'Username',
                          key: 'username',
                          validator: (val) =>
                              (val == null || val.isEmpty) ? 'Please enter something' : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Loading spinner overlay
            if (isLoading)
              const Positioned.fill(
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    ),
  );
}
}
