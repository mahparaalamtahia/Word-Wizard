import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final SupabaseClient supabase;
  SupabaseAuthService(this.supabase);

  Future<AuthResponse> signUpUser({required String email, required String password}) async {
    return await supabase.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<void> createProfile({required String id, String? fullName, String? phone, required String email, String role = 'user'}) async {
    await supabase.from('profiles').insert({
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'role': role,
    });
  }

  Future<void> createWorkerProfile({required String id, required String categoryId, int experience = 0, double hourlyRate = 0.0, String? location, String? bio}) async {
    await supabase.from('workers').insert({
      'id': id,
      'category_id': categoryId,
      'experience': experience,
      'hourly_rate': hourlyRate,
      'location': location,
      'bio': bio,
    });
  }

  User? get currentUser => supabase.auth.currentUser;

  Stream<AuthState> authStateChanges() => supabase.auth.onAuthStateChange;
}
