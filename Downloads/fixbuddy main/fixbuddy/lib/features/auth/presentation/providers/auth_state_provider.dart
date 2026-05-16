import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/user_role_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_providers.dart';

String resolvePostLoginRoute(
  UserEntity user, {
  // keep signature for future worker-mode support
  dynamic workerMode,
}) {
  switch (user.role) {
    case 'admin':
      return AppRoutes.admin;
    case 'worker':
    case 'user':
    default:
      return AppRoutes.shell;
  }
}

/// Auth state to hold current user and loading/error state
class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final bool requiresEmailVerification;
  final String? pendingVerificationEmail;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.requiresEmailVerification = false,
    this.pendingVerificationEmail,
  });

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    bool? requiresEmailVerification,
    String? pendingVerificationEmail,
    bool clearPendingVerificationEmail = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      requiresEmailVerification:
          requiresEmailVerification ?? this.requiresEmailVerification,
      pendingVerificationEmail: clearPendingVerificationEmail
          ? null
          : pendingVerificationEmail ?? this.pendingVerificationEmail,
    );
  }

  static const initial = AuthState();

  AuthState loading() => copyWith(isLoading: true, error: null);
  AuthState success(UserEntity user) =>
      copyWith(
        user: user,
        isAuthenticated: true,
        requiresEmailVerification: false,
        pendingVerificationEmail: null,
        isLoading: false,
      );
  AuthState pendingVerification(UserEntity user, String email) => copyWith(
        user: user,
        isAuthenticated: false,
        requiresEmailVerification: true,
        pendingVerificationEmail: email,
        isLoading: false,
        error: null,
      );
  AuthState withError(String error) => copyWith(error: error, isLoading: false);
  AuthState logout() => const AuthState();
}

class AuthNotifier extends StateNotifier<AuthState> {
  final RegisterUsecase registerUsecase;
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final GetCurrentUserUsecase getCurrentUserUsecase;

  AuthNotifier({
    required this.registerUsecase,
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.getCurrentUserUsecase,
  }) : super(AuthState.initial);

  Future<void> register({
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
    BuildContext? context,
  }) async {
    state = state.loading();

    final result = await registerUsecase(
      email: email,
      password: password,
      name: name,
      role: role,
      phone: phone,
      categoryId: categoryId,
      experienceYears: experienceYears,
      hourlyRate: hourlyRate,
      serviceArea: serviceArea,
      bio: bio,
    );

    result.fold(
      (failure) => state = state.withError(failure.message),
      (user) {
        final hasActiveSession = SupabaseService.client.auth.currentSession != null;

        if (!hasActiveSession) {
          state = state.pendingVerification(user, email);
          if (context != null) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.verifyEmail,
              (_) => false,
              arguments: {'email': email},
            );
          }
          return;
        }

        state = state.success(user);
        if (context != null) _handleAuthSuccess(context, user);
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    state = state.loading();

    final result = await loginUsecase(email: email, password: password);

    result.fold(
      (failure) => state = state.withError(failure.message),
      (user) {
        state = state.success(user);
        if (context != null) _handleAuthSuccess(context, user);
      },
    );
  }

  Future<void> logout([BuildContext? context]) async {
    state = state.loading();
    final result = await logoutUsecase();

    result.fold(
      (failure) => state = state.withError(failure.message),
      (_) {
        state = state.logout();
        if (context != null) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
      },
    );
  }

  Future<void> _handleAuthSuccess(BuildContext context, UserEntity user) async {
    final roleService = UserRoleService(SupabaseService.client);
    final role = await roleService.getCurrentUserRole();

    if (!context.mounted) return;

    switch (role) {
      case 'admin':
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.adminShell, (_) => false);
        break;
      case 'worker':
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.workerShell, (_) => false);
        break;
      case 'user':
      default:
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.shell, (_) => false);
    }
  }

  /// Get current user
  Future<void> getCurrentUser() async {
    final result = await getCurrentUserUsecase();

    result.fold(
      (failure) => state = state.withError(failure.message),
      (user) {
        if (user != null) {
          state = state.success(user);
        } else {
          state = state.logout();
        }
      },
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearVerificationState() {
    state = state.copyWith(
      requiresEmailVerification: false,
      clearPendingVerificationEmail: true,
    );
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final registerUsecase = ref.watch(registerUsecaseProvider);
  final loginUsecase = ref.watch(loginUsecaseProvider);
  final logoutUsecase = ref.watch(logoutUsecaseProvider);
  final getCurrentUserUsecase = ref.watch(getCurrentUserUsecaseProvider);

  return AuthNotifier(
    registerUsecase: registerUsecase,
    loginUsecase: loginUsecase,
    logoutUsecase: logoutUsecase,
    getCurrentUserUsecase: getCurrentUserUsecase,
  );
});

/// Provider for getting current user
final currentUserProvider = FutureProvider<UserEntity?>((ref) async {
  final authNotifier = ref.watch(authStateProvider.notifier);
  await authNotifier.getCurrentUser();
  final state = ref.watch(authStateProvider);
  return state.user;
});
