

import 'package:supabase_flutter/supabase_flutter.dart';


/// Returns the currently logged-in user's data, or `null` if not logged in.
// Future<User?> getCurrentUserData() async {
//   final client = Supabase.instance.client;
//   return client.auth.currentUser;
// }

/// Returns only the user ID, or `null` if not logged in.
Future<String?> getCurrentUserId() async {
  final user = Supabase.instance.client.auth.currentUser;
  return user?.id;
}