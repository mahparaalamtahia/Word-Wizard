import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';

/// Abstract repository for profile operations
abstract class ProfileRepository {
  /// Fetch user profile by ID
  Future<Either<Failure, ProfileEntity>> getProfile(String userId);

  /// Update user profile with provided data
  Future<Either<Failure, ProfileEntity>> updateProfile(String userId, Map<String, dynamic> data);

  /// Upload profile photo
  Future<Either<Failure, String>> uploadProfilePhoto(String userId, String filePath);

  /// Delete profile photo
  Future<Either<Failure, void>> deleteProfilePhoto(String userId);

  /// Check if username exists
  Future<Either<Failure, bool>> checkUsernameExists(String username);

  /// Search profiles by name or email
  Future<Either<Failure, List<ProfileEntity>>> searchProfiles(String query, int limit);
}
