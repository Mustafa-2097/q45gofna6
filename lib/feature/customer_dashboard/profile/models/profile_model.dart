class ProfileModel {
  final String id;
  final String email;
  final String role;
  final String status;
  final ProfileData profile;

  ProfileModel({
    required this.id,
    required this.email,
    required this.role,
    required this.status,
    required this.profile,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      profile: ProfileData.fromJson(json['profile'] ?? {}),
    );
  }
}

class ProfileData {
  final String name;
  final String? avatar;
  final String? companyName;
  final String? phone;
  final String? description;

  ProfileData({
    required this.name,
    this.avatar,
    this.companyName,
    this.phone,
    this.description,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      name: json['name'] ?? '',
      avatar: json['avatar'],
      companyName: json['companyName'],
      phone: json['phone'],
      description: json['description'],
    );
  }
}
