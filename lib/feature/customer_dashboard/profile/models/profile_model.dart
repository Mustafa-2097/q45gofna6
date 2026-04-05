import '../../subscription/models/subscription_model.dart';

class ProfileModel {
  final String id;
  final String email;
  final String role;
  final String status;
  final ProfileData profile;
  final UserSubscription? subscription;

  ProfileModel({
    required this.id,
    required this.email,
    required this.role,
    required this.status,
    required this.profile,
    this.subscription,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      profile: ProfileData.fromJson(json['profile'] ?? {}),
      subscription: json['activeSubscription'] != null 
          ? UserSubscription.fromJson(json['activeSubscription']) 
          : (json['subscription'] != null ? UserSubscription.fromJson(json['subscription']) : null),
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

  String get cleanedAvatarUrl {
    if (avatar == null || avatar!.isEmpty) return '';
    
    String url = avatar!;
    // Replace localhost/127.0.0.1 with the actual IP
    if (url.contains('localhost')) {
      url = url.replaceFirst('localhost:5000', '206.162.244.189:5005');
    } else if (url.contains('127.0.0.1')) {
      url = url.replaceFirst('127.0.0.1:5000', '206.162.244.189:5005');
    }
    
    // If it's a relative path, prepend the base URL
    if (!url.startsWith('http')) {
      if (url.startsWith('/')) {
        url = 'http://206.162.244.189:5005$url';
      } else {
        url = 'http://206.162.244.189:5005/$url';
      }
    }
    
    return url;
  }
}
