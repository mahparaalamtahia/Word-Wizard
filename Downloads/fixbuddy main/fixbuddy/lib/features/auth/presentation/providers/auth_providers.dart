import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import '../../../../core/services/supabase_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

/// Provider for Supabase service
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

/// Provider for Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return SupabaseService.client;
});

/// Provider for remote data source
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRemoteDataSource(supabaseClient: client);
});

/// Provider for auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: dataSource);
});

/// Provider for register use case
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUsecase(repository);
});

/// Provider for login use case
final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUsecase(repository);
});

/// Provider for logout use case
final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUsecase(repository);
});

/// Provider for get current user use case
final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUsecase(repository);
});

/// Provider for session validation use case
final isSessionValidUsecaseProvider = Provider<IsSessionValidUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return IsSessionValidUsecase(repository);
});

/// Provider for update profile use case
final updateUserProfileUsecaseProvider =
    Provider<UpdateUserProfileUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return UpdateUserProfileUsecase(repository);
});
