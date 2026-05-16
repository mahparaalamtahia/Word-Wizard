/// User entity representing a user in the system
class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String role; // 'user', 'worker', 'admin'
  final String? phone;
  final String? photoUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    this.phone,
    this.photoUrl,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create a copy with optional modifications
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? phone,
    String? photoUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'UserEntity(id: $id, email: $email, name: $name, role: $role)';
}
