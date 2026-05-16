import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
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
  }) async {
    try {
      final user = await remoteDataSource.register(
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
      return Right(user);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          code: e.code,
        ),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Registration failed: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(
        AuthFailure(
          message: e.message,
          code: e.code,
        ),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Login failed: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Logout failed: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to get current user: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isSessionValid() async {
    try {
      final isValid = await remoteDataSource.isSessionValid();
      return Right(isValid);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to validate session',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile({
    required String userId,
    String? name,
    String? phone,
    String? photoUrl,
  }) async {
    try {
      final user = await remoteDataSource.updateUserProfile(
        userId: userId,
        name: name,
        phone: phone,
        photoUrl: photoUrl,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to update profile: $e',
        ),
      );
    }
  }

  @override
  Stream<Either<Failure, UserEntity?>> get authStateStream {
    return remoteDataSource.authStateChanges().map<Either<Failure, UserEntity?>>(
      (user) => Right<Failure, UserEntity?>(user),
    );
  }
}
