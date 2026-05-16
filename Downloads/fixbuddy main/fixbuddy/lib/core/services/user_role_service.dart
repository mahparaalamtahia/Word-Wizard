import 'package:supabase_flutter/supabase_flutter.dart';

/// Single source of truth for reading the current user's role.
/// Reads from public.profiles table — DB is authoritative.
class UserRoleService {
  final SupabaseClient _client;
  UserRoleService(this._client);

  /// Returns 'user' | 'worker' | 'admin'
  /// Defaults to 'user' on error or missing data.
  Future<String> getCurrentUserRole() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return 'user';

      final response = await _client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return 'user';

      final role = (response as Map<String, dynamic>)['role'] as String?;
      return role ?? 'user';
    } catch (_) {
      return 'user';
    }
  }

  Future<bool> isAdmin() async => await getCurrentUserRole() == 'admin';
  Future<bool> isWorker() async => await getCurrentUserRole() == 'worker';
}
