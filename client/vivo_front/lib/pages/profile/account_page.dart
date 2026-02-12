import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? '—';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Email'),
            subtitle: Text(email),
          ),
          const Divider(height: 1),
          const ListTile(
            title: Text('Phone'),
            subtitle: Text('+1 (555) 555-5555'),
          ),
          const Divider(height: 1),
          const ListTile(
            title: Text('Password'),
            subtitle: Text('Last updated recently'),
          ),
        ],
      ),
    );
  }
}
