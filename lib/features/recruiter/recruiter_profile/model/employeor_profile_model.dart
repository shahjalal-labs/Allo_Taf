class EmployerProfileModel {
  final bool success;
  final String message;
  final EmployerProfileData? result;

  EmployerProfileModel({
    required this.success,
    required this.message,
    this.result,
  });

  factory EmployerProfileModel.fromJson(Map<String, dynamic> json) {
    return EmployerProfileModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      result: json['result'] != null
          ? EmployerProfileData.fromJson(json['result'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'result': result?.toJson()};
  }
}

class EmployerProfileData {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String phoneNumber;
  final String city;
  final String neighborhood;
  final String bio;
  final String profileImage;
  final List<String> designation;
  final List<String> skills;
  final String? availabilityStart;
  final String? availabilityEnd;
  final String? cv;
  final String contactPerson;
  final DateTime? createdAt;
  final bool? isSubscribed;
  final DateTime? subscriptionExpireAt;
  final String? subscriptionStatus;

  EmployerProfileData({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.phoneNumber,
    required this.city,
    required this.neighborhood,
    required this.bio,
    required this.profileImage,
    required this.designation,
    required this.skills,
    this.availabilityStart,
    this.availabilityEnd,
    this.cv,
    required this.contactPerson,
    this.createdAt,
    this.isSubscribed,
    this.subscriptionExpireAt,
    this.subscriptionStatus,
  });

  factory EmployerProfileData.fromJson(Map<String, dynamic> json) {
    return EmployerProfileData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      city: json['city'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      bio: json['bio'] ?? '',
      profileImage: json['profileImage'] ?? '',
      designation: json['designation'] != null
          ? List<String>.from(json['designation'])
          : [],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      availabilityStart: json['availabilityStart'],
      availabilityEnd: json['availabilityEnd'],
      cv: json['cv'],
      contactPerson: json['contactPerson'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      isSubscribed: json['isSubscribed'],
      subscriptionExpireAt: json['subscriptionExpireAt'] != null
          ? DateTime.tryParse(json['subscriptionExpireAt'])
          : null,
      subscriptionStatus: json['subscriptionStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role,
      'phoneNumber': phoneNumber,
      'city': city,
      'neighborhood': neighborhood,
      'bio': bio,
      'profileImage': profileImage,
      'designation': designation,
      'skills': skills,
      'availabilityStart': availabilityStart,
      'availabilityEnd': availabilityEnd,
      'cv': cv,
      'contactPerson': contactPerson,
      'createdAt': createdAt?.toIso8601String(),
      'isSubscribed': isSubscribed,
      'subscriptionExpireAt': subscriptionExpireAt?.toIso8601String(),
      'subscriptionStatus': subscriptionStatus,
    };
  }
}
