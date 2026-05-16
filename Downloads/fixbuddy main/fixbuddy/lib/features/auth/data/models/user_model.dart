import '../../domain/entities/user_entity.dart';

/// User model for Supabase database
class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    super.name,
    required super.role,
    super.phone,
    super.photoUrl,
    required super.isActive,
    required super.createdAt,
    super.updatedAt,
  });

  /// Convert from JSON (Supabase response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: (json['full_name'] ?? json['name']) as String?,
      role: json['role'] as String? ?? 'user',
      phone: json['phone'] as String?,
      photoUrl: json['photo_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': name,
      'role': role,
      'phone': phone,
      'photo_url': photoUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Convert UserEntity to UserModel
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      role: entity.role,
      phone: entity.phone,
      photoUrl: entity.photoUrl,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
