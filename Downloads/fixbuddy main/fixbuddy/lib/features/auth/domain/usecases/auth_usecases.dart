import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user registration
class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call({
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
    return await repository.register(
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
  }
}

/// Use case for user login
class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(
      email: email,
      password: password,
    );
  }
}

/// Use case for user logout
class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}

/// Use case to get current user
class GetCurrentUserUsecase {
  final AuthRepository repository;

  GetCurrentUserUsecase(this.repository);

  Future<Either<Failure, UserEntity?>> call() async {
    return await repository.getCurrentUser();
  }
}

/// Use case to check if session is valid
class IsSessionValidUsecase {
  final AuthRepository repository;

  IsSessionValidUsecase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.isSessionValid();
  }
}

/// Use case to update user profile
class UpdateUserProfileUsecase {
  final AuthRepository repository;

  UpdateUserProfileUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String userId,
    String? name,
    String? phone,
    String? photoUrl,
  }) async {
    return await repository.updateUserProfile(
      userId: userId,
      name: name,
      phone: phone,
      photoUrl: photoUrl,
    );
  }
}
