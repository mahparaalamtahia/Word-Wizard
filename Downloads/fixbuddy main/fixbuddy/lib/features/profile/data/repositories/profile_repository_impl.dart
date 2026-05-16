import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

/// Implementation of ProfileRepository
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String userId) async {
    try {
      final profile = await remoteDataSource.getProfile(userId);
      return right(profile);
    } catch (e) {
      return left(ServerFailure(message: 'Failed to fetch profile: $e'));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(String userId, Map<String, dynamic> data) async {
    try {
      final profile = await remoteDataSource.updateProfile(userId, data);
      return right(profile);
    } catch (e) {
      return left(ServerFailure(message: 'Failed to update profile: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePhoto(String userId, String filePath) async {
    try {
      final photoUrl = await remoteDataSource.uploadProfilePhoto(userId, filePath);
      return right(photoUrl);
    } catch (e) {
      return left(ServerFailure(message: 'Failed to upload profile photo: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfilePhoto(String userId) async {
    try {
      await remoteDataSource.deleteProfilePhoto(userId);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: 'Failed to delete profile photo: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkUsernameExists(String username) async {
    try {
      final exists = await remoteDataSource.checkUsernameExists(username);
      return right(exists);
    } catch (e) {
      return left(ServerFailure(message: 'Failed to check username: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProfileEntity>>> searchProfiles(String query, int limit) async {
    try {
      final profiles = await remoteDataSource.searchProfiles(query, limit);
      return right(profiles.cast<ProfileEntity>());
    } catch (e) {
      return left(ServerFailure(message: 'Failed to search profiles: $e'));
    }
  }
}
