

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

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


String formatEventTime(String? isoString) {
      if (isoString == null || isoString.isEmpty) return 'TBD';
      try {
        DateTime dt = DateTime.parse(isoString).toLocal();
        // Pattern: MMM (Month) d (Day), h:mm a (Hour:Min AM/PM)
        return DateFormat('MMM d, h:mm a').format(dt);
      } catch (e) {
        return 'Invalid Date';
      }
    }