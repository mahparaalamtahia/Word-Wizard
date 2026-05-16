import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

/// Abstract repository for authentication
abstract class AuthRepository {
  /// Register a new user with email and password
  /// Returns either a Failure or the created UserEntity
  Future<Either<Failure, UserEntity>> register({
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
  });

  /// Login user with email and password
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Logout the current user
  Future<Either<Failure, void>> logout();

  /// Get current authenticated user
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Check if user session is valid
  Future<Either<Failure, bool>> isSessionValid();

  /// Update user profile
  Future<Either<Failure, UserEntity>> updateUserProfile({
    required String userId,
    String? name,
    String? phone,
    String? photoUrl,
  });

  /// Stream of authentication state changes
  Stream<Either<Failure, UserEntity?>> get authStateStream;
}
