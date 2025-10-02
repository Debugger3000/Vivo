



// lib/screens/login.dart
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supabase_ui/supabase_ui.dart';

import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400, // optional: restrict width for web
          child: SupaEmailAuth(
            redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
            onSignInComplete: (response) {
              // Example: navigate to home page
              if (response.user != null) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
            onSignUpComplete: (response) {
              // Example: navigate to welcome page
              if (response.user != null) {
                Navigator.pushReplacementNamed(context, '/welcome');
              }
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
