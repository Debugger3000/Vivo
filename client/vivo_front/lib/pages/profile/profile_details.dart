import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final metadata = user?.userMetadata ?? const {};
    final username =
        (metadata['username'] is String && (metadata['username'] as String).trim().isNotEmpty)
            ? (metadata['username'] as String).trim()
            : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Name'),
            subtitle: Text(
              '—',
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Username'),
            subtitle: Text(username.isNotEmpty ? '@$username' : '—'),
          ),
          const Divider(height: 1),
          const ListTile(
            title: Text('Bio'),
            subtitle: Text('Tap to edit your bio.'),
          ),
        ],
      ),
    );
  }
}
