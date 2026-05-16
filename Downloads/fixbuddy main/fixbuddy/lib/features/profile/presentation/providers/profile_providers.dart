import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase hide Provider;

import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

// Supabase instance provider
final supabaseInstanceProvider = Provider<supabase.SupabaseClient>((ref) {
  return supabase.Supabase.instance.client;
});

// Profile repository provider (dependency injection)
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final supabaseClient = ref.watch(supabaseInstanceProvider);
  final remoteDataSource = ProfileRemoteDataSourceImpl(supabase: supabaseClient);
  return ProfileRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Get profile by user ID provider (FutureProvider with auto dispose)
final getProfileProvider = FutureProvider.autoDispose.family<ProfileEntity, String>((ref, userId) async {
  final repository = ref.watch(profileRepositoryProvider);
  final result = await repository.getProfile(userId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (profile) => profile,
  );
});

// Update profile state notifier
class ProfileUpdateNotifier extends StateNotifier<AsyncValue<ProfileEntity>> {
  final ProfileRepository _repository;

  ProfileUpdateNotifier(this._repository) : super(const AsyncValue.loading());

  /// Update profile with given data
  Future<ProfileEntity?> updateProfile(String userId, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    final result = await _repository.updateProfile(userId, data);
    final AsyncValue<ProfileEntity> nextState = result.fold(
      (failure) => AsyncValue.error(Exception(failure.message), StackTrace.current),
      (profile) => AsyncValue.data(profile),
    );
    state = nextState;
    return nextState.valueOrNull;
  }

  /// Upload profile photo
  Future<String?> uploadProfilePhoto(String userId, String filePath) async {
    state = const AsyncValue.loading();
    final result = await _repository.uploadProfilePhoto(userId, filePath);
    return result.fold(
      (failure) {
        state = AsyncValue.error(Exception(failure.message), StackTrace.current);
        return null;
      },
      (photoUrl) {
        // Update state with new photo URL
        if (state.hasValue) {
          final currentProfile = state.value!;
          state = AsyncValue.data(currentProfile.copyWith(photoUrl: photoUrl));
        }
        return photoUrl;
      },
    );
  }

  /// Delete profile photo
  Future<void> deleteProfilePhoto(String userId) async {
    state = const AsyncValue.loading();
    final result = await _repository.deleteProfilePhoto(userId);
    result.fold(
      (failure) => state = AsyncValue.error(Exception(failure.message), StackTrace.current),
      (_) {
        if (state.hasValue) {
          final currentProfile = state.value!;
          state = AsyncValue.data(currentProfile.copyWith(photoUrl: null));
        }
      },
    );
  }
}

// Update profile provider
final profileUpdateProvider = StateNotifierProvider<ProfileUpdateNotifier, AsyncValue<ProfileEntity>>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileUpdateNotifier(repository);
});

// Check username existence provider
final checkUsernameProvider = FutureProvider.autoDispose.family<bool, String>((ref, username) async {
  final repository = ref.watch(profileRepositoryProvider);
  final result = await repository.checkUsernameExists(username);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (exists) => exists,
  );
});

// Search profiles provider
final searchProfilesProvider = FutureProvider.autoDispose.family<List<ProfileEntity>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final repository = ref.watch(profileRepositoryProvider);
  final result = await repository.searchProfiles(query, 20);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (profiles) => profiles,
  );
});
