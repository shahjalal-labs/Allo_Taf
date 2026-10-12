class MyProfileModel {
  final bool? success;
  final String? message;
  final ProfileData? result;

  MyProfileModel({this.success, this.message, this.result});

  factory MyProfileModel.fromJson(Map<String, dynamic> json) {
    return MyProfileModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      result: json['result'] is Map<String, dynamic>
          ? ProfileData.fromJson(json['result'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'result': result?.toJson()};
  }
}

class ProfileData {
  final String? id;
  final String? email;
  final String? fullName;
  final String? role;
  final String? phoneNumber;
  final String? city;
  final String? neighborhood;
  final String? bio;
  final String? profileImage;
  final List<String>? designation;
  final List<String>? skills;
  final DateTime? availabilityStart;
  final DateTime? availabilityEnd;
  final String? cv;
  final String? contactPerson;
  final String? createdAt;
  final bool? isSubscribed;
  final DateTime? subscriptionExpireAt;
  final String? subscriptionStatus;

  ProfileData({
    this.id,
    this.email,
    this.fullName,
    this.role,
    this.phoneNumber,
    this.city,
    this.neighborhood,
    this.bio,
    this.profileImage,
    this.designation,
    this.skills,
    this.availabilityStart,
    this.availabilityEnd,
    this.cv,
    this.contactPerson,
    this.createdAt,
    this.isSubscribed,
    this.subscriptionExpireAt,
    this.subscriptionStatus,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id']?.toString(),
      email: json['email']?.toString(),
      fullName: json['fullName']?.toString(),
      role: json['role']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      city: json['city']?.toString(),
      neighborhood: json['neighborhood']?.toString(),
      bio: json['bio']?.toString(),
      profileImage: json['profileImage']?.toString(),
      designation: (json['designation'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      availabilityStart: json['availabilityStart'] != null
          ? DateTime.tryParse(json['availabilityStart'].toString())
          : null,
      availabilityEnd: json['availabilityEnd'] != null
          ? DateTime.tryParse(json['availabilityEnd'].toString())
          : null,
      cv: json['cv']?.toString(),
      contactPerson: json['contactPerson']?.toString(),
      createdAt: json['createdAt']?.toString(),
      isSubscribed: json['isSubscribed'] is bool
          ? json['isSubscribed'] as bool
          : null,
      subscriptionExpireAt: json['subscriptionExpireAt'] != null
          ? DateTime.tryParse(json['subscriptionExpireAt'].toString())
          : null,
      subscriptionStatus: json['subscriptionStatus']?.toString(),
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
      'availabilityStart': availabilityStart?.toIso8601String(),
      'availabilityEnd': availabilityEnd?.toIso8601String(),
      'cv': cv,
      'contactPerson': contactPerson,
      'createdAt': createdAt,
      'isSubscribed': isSubscribed,
      'subscriptionExpireAt': subscriptionExpireAt?.toIso8601String(),
      'subscriptionStatus': subscriptionStatus,
    };
  }
}
