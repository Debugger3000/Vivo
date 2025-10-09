// lib/screens/login.dart

// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supabase_ui/supabase_ui.dart';

import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
// import 'package:supabase_ui/supabase_ui.dart';
import 'package:vivo_front/navigation_wrapper.dart';

import 'package:supabase_auth_ui/supabase_auth_ui.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vivo')),
      body: Center(
        child: SizedBox(
          width: 400, // optional: restrict width for web
          child: SupaEmailAuth(
            redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
            onSignInComplete: (response) async {
              setState(() {
                isLoading = true;
              });

              final user = response.user;
              // final error = response.error;

              if (user != null && context.mounted) {
                // 👇 Replace current page (login) with the NavigationWrapper
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const NavigationWrapper()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Authentication failed')),
                );
              }

              setState(() {
                isLoading = false;
              });
            },

            onSignUpComplete: (response) async {
              setState(() {
                isLoading = true;
              });

              final user = response.user;
              // final error = response.error;

              if (user != null) {
                Navigator.pushReplacementNamed(context, '/map');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sign up error: $response')),
                );
              }

              setState(() {
                isLoading = false;
              });
            },

            metadataFields: [
              MetaDataField(
                prefixIcon: const Icon(Icons.person),
                label: 'Username',
                key: 'username',
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter something';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
