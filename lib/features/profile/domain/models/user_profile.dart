class UserProfile {
  const UserProfile({required this.id, this.fullName, this.avatarUrl});

  final String id;
  final String? fullName;
  final String? avatarUrl;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}
