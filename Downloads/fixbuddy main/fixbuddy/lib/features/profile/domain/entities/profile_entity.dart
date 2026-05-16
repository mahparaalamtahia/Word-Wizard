/// Profile entity extending user with additional profile fields
class ProfileEntity {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String? photoUrl;
  final String? bio;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final String role; // 'user', 'worker', 'admin'
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProfileEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.photoUrl,
    this.bio,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    required this.role,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create a copy with optional modifications
  ProfileEntity copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? photoUrl,
    String? bio,
    String? address,
    String? city,
    String? state,
    String? country,
    String? zipCode,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileEntity && runtimeType == other.runtimeType && id == other.id && email == other.email && fullName == other.fullName;

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ fullName.hashCode;
}
