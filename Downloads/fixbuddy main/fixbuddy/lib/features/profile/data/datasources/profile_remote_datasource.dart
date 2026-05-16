import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

import '../models/profile_model.dart';

/// Abstract interface for profile remote data access
abstract class ProfileRemoteDataSource {
  /// Fetch user profile by ID
  Future<ProfileModel> getProfile(String userId);

  /// Update user profile
  Future<ProfileModel> updateProfile(String userId, Map<String, dynamic> data);

  /// Upload profile photo
  Future<String> uploadProfilePhoto(String userId, String filePath);

  /// Delete profile photo
  Future<void> deleteProfilePhoto(String userId);

  /// Check if username exists
  Future<bool> checkUsernameExists(String username);

  /// Search profiles by full name or email
  Future<List<ProfileModel>> searchProfiles(String query, int limit);
}

/// Implementation of ProfileRemoteDataSource using Supabase
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabase;

  ProfileRemoteDataSourceImpl({required this.supabase});

  @override
  Future<ProfileModel> getProfile(String userId) async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return ProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  @override
  Future<ProfileModel> updateProfile(String userId, Map<String, dynamic> data) async {
    try {
      final response = await supabase
          .from('profiles')
          .update({
            ...data,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();
      return ProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<String> uploadProfilePhoto(String userId, String filePath) async {
    try {
      final fileName = 'profiles/$userId/photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Convert string to Uint8List for upload
      final bytes = Uint8List.fromList(filePath.codeUnits);
      
      await supabase.storage.from('avatars').uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl = supabase.storage.from('avatars').getPublicUrl(fileName);
      await updateProfile(userId, {'photo_url': publicUrl});

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload profile photo: $e');
    }
  }

  @override
  Future<void> deleteProfilePhoto(String userId) async {
    try {
      // Get current photo URL
      final profile = await getProfile(userId);
      if (profile.photoUrl != null && profile.photoUrl!.isNotEmpty) {
        // Extract file path from URL
        final uri = Uri.parse(profile.photoUrl!);
        final pathSegments = uri.pathSegments;
        final filePath = pathSegments.sublist(3).join('/'); // Skip bucket name

        // Delete from storage
        await supabase.storage.from('avatars').remove([filePath]);

        // Update profile
        await updateProfile(userId, {'photo_url': null});
      }
    } catch (e) {
      throw Exception('Failed to delete profile photo: $e');
    }
  }

  @override
  Future<bool> checkUsernameExists(String username) async {
    try {
      final response = await supabase
          .from('profiles')
          .select('id')
          .eq('full_name', username)
          .maybeSingle();
      return response != null;
    } catch (e) {
      throw Exception('Failed to check username: $e');
    }
  }

  @override
  Future<List<ProfileModel>> searchProfiles(String query, int limit) async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .or('full_name.ilike.%$query%,email.ilike.%$query%')
          .limit(limit);
      return (response as List).map((p) => ProfileModel.fromJson(p as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to search profiles: $e');
    }
  }
}
