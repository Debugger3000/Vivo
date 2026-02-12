/* // lib/screens/login.dart
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
} */


// lib/screens/login.dart
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vivo_front/navigation_wrapper.dart';
import 'package:vivo_front/pages/login_register/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const _mobileRedirect = 'com.example.vivo_front://login-callback';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;
  StreamSubscription<AuthState>? _authSub;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _wireDeepLinks();
    _listenAuthChanges();
  }

  void _listenAuthChanges() {
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((e) {
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

    _linkSub = _appLinks.uriLinkStream.listen(_handleAuthLink);
  }

  Future<void> _handleAuthLink(Uri uri) async {
    final isValid =
        uri.scheme == 'com.example.vivo_front' &&
        (uri.host == 'login-callback' ||
            uri.path.contains('login-callback'));

    if (!isValid) return;

    try {
      setState(() => isLoading = true);
      await Supabase.instance.client.auth
          .exchangeCodeForSession(uri.toString());
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not complete sign-in')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _signIn() async {
    setState(() => isLoading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _linkSub?.cancel();
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // VIVO pill
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9FF3FF),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 15,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      child: const Text(
                        'VIVO',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 62),

                    // Email
                    _InputField(
                      label: 'Email',
                      controller: _emailController,
                      hint: 'email@example.com',
                    ),

                    const SizedBox(height: 50),

                    // Password
                    _InputField(
                      label: 'Password',
                      controller: _passwordController,
                      obscure: true,
                      hint: '********',
                    ),

                    const Spacer(),

                    // Login button
                    GestureDetector(
                      onTap: isLoading ? null : _signIn,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9FF3FF),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 20,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // const Text(
                    //   'Log In as a Business',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                     GestureDetector(
                      onTap: () =>  Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    ),
                      child: const Text(
                        'Don\'t have an account? Register Now!',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 56),
                  ],
                ),
              ),
            ),

            if (isLoading)
              const Positioned.fill(
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscure;

  const _InputField({
    required this.label,
    required this.controller,
    this.hint = '',
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        //color: const Color.fromARGB(255, 161, 53, 53),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              border: UnderlineInputBorder(
                borderSide: BorderSide(width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1.0, color: const Color(0xFF9FF3FF))
                  )
            ),
          ),
        ],
      ),
    );
  }
}

