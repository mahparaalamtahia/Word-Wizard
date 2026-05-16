import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/routes/app_routes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Remote data source for authentication (Supabase)
class AuthRemoteDataSource {
  final supabase.SupabaseClient supabaseClient;

  AuthRemoteDataSource({required this.supabaseClient});

  /// Register a new user
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
    String? categoryId,
    int? experienceYears,
    double? hourlyRate,
    String? serviceArea,
    String? bio,
  }) async {
    try {
      final emailRedirectTo = kIsWeb ? '${Uri.base.origin}/#${AppRoutes.login}' : null;

      // Sign up with email and password
      final authResponse = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: emailRedirectTo,
        data: {
          'full_name': name,
          'name': name,
          'role': role,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
        },
      );

      final authUser = authResponse.user ?? supabaseClient.auth.currentUser;

      if (authUser == null) {
        throw ServerException(
          message: 'Account created but user session is not available yet. Please verify email and login.',
        );
      }

      final hasActiveSession = supabaseClient.auth.currentSession != null;

      if (!hasActiveSession) {
        return UserModel.fromJson({
          'id': authUser.id,
          'email': authUser.email ?? email,
          'full_name': name,
          'role': role,
          'phone': phone,
          'photo_url': null,
          'is_active': true,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      // Insert/Upsert profile first (id must match auth.uid()).
      final profile = await supabaseClient
          .from(AppConstants.profilesTable)
          .upsert({
            'id': authUser.id,
            'email': authUser.email ?? email,
            'full_name': name,
            'phone': phone,
            'role': role,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      // Insert worker row only after profile exists and the session is active.
      if (role == AppConstants.roleWorker) {
        if (categoryId == null || categoryId.isEmpty) {
          throw ServerException(message: 'Worker category is required');
        }

        await supabaseClient
            .from(AppConstants.workersTable)
            .upsert({
              'id': authUser.id,
              'category_id': categoryId,
              'experience_years': experienceYears ?? 0,
              'hourly_rate': hourlyRate ?? 0,
              'service_area': serviceArea,
              'bio': bio,
              'is_available': true,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .select()
            .single();
      }

      return UserModel.fromJson(profile as Map<String, dynamic>);
    } on supabase.AuthException catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    } catch (e) {
      throw ServerException(
        message: 'Registration failed: $e',
      );
    }
  }

  /// Login user
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw ServerException(
          message: 'Login failed',
        );
      }

      // Fetch user profile from users table
      final response = await supabaseClient
          .from(AppConstants.profilesTable)
          .select()
          .eq('id', authResponse.user!.id)
          .maybeSingle();

      if (response == null) {
        final createdProfile = await supabaseClient
            .from(AppConstants.profilesTable)
            .upsert({
              'id': authResponse.user!.id,
              'email': authResponse.user!.email,
              'full_name': authResponse.user!.userMetadata?['full_name'],
              'phone': authResponse.user!.phone,
              'role': authResponse.user!.userMetadata?['role'] ?? AppConstants.roleUser,
              'created_at': DateTime.now().toIso8601String(),
            })
            .select()
            .single();
        return UserModel.fromJson(createdProfile as Map<String, dynamic>);
      }

      return UserModel.fromJson(response as Map<String, dynamic>);
    } on supabase.AuthException {
      throw ServerException(
        message: 'Invalid email or password',
      );
    } catch (e) {
      throw ServerException(
        message: 'Login failed: $e',
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(
        message: 'Logout failed: $e',
      );
    }
  }

  /// Get current user from Supabase
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;

      if (user == null) {
        return null;
      }

        // Fetch user profile from profiles table
      final response = await supabaseClient
          .from(AppConstants.profilesTable)
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return UserModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(
        message: 'Failed to fetch user: $e',
      );
    }
  }

  /// Check if session is valid
  Future<bool> isSessionValid() async {
    try {
      final session = supabaseClient.auth.currentSession;
      return session != null;
    } catch (e) {
      return false;
    }
  }

  /// Update user profile
  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? phone,
    String? photoUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'id': userId,
        'email': supabaseClient.auth.currentUser?.email,
      };

      if (name != null && name.trim().isNotEmpty) {
        updateData['full_name'] = name.trim();
      }
      if (phone != null && phone.trim().isNotEmpty) {
        updateData['phone'] = phone.trim();
      }
      if (photoUrl != null && photoUrl.trim().isNotEmpty) {
        updateData['photo_url'] = photoUrl.trim();
      }

      final response = await supabaseClient
          .from(AppConstants.profilesTable)
          .upsert(updateData)
          .select()
          .single();

      return UserModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(
        message: 'Failed to update profile: $e',
      );
    }
  }

  /// Stream of auth state changes
  Stream<UserModel?> authStateChanges() {
    return supabaseClient.auth.onAuthStateChange.asyncMap((data) async {
      if (data.session == null) {
        return null;
      }

      try {
        return await getCurrentUser();
      } catch (e) {
        return null;
      }
    });
  }
}
