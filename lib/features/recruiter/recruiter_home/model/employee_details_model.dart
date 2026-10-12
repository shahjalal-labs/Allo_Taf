import 'dart:convert';

/// Helper function to parse raw JSON string
EmployeeDetailsModel employeeDetailsModelFromJson(String str) =>
    EmployeeDetailsModel.fromJson(json.decode(str));

String employeeDetailsModelToJson(EmployeeDetailsModel data) =>
    json.encode(data.toJson());

// --- Main Root Model ---
class EmployeeDetailsModel {
  final bool success;
  final String message;
  final EmployeeDetailsResult result;

  EmployeeDetailsModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory EmployeeDetailsModel.fromJson(Map<String, dynamic> json) {
    return EmployeeDetailsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      result: EmployeeDetailsResult.fromJson(json['result'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'result': result.toJson(),
  };
}

// --- User Profile Result Model ---
class EmployeeDetailsResult {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String phoneNumber;
  final String city;
  final String neighborhood;
  final String bio;
  final String? profileImage;
  final List<String> skills;
  final String? availabilityStart;
  final String? availabilityEnd;
  final String? cv;
  final String? contactPerson;
  final DateTime createdAt;
  final bool? isSubscribed;
  final String? subscriptionExpireAt;
  final ReviewStats reviewStats;
  final List<RecentReview> recentReviews;
  final bool isReviewGiven;
  final int jobPostCount;

  EmployeeDetailsResult({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.phoneNumber,
    required this.city,
    required this.neighborhood,
    required this.bio,
    this.profileImage,
    required this.skills,
    this.availabilityStart,
    this.availabilityEnd,
    this.cv,
    this.contactPerson,
    required this.createdAt,
    this.isSubscribed,
    this.subscriptionExpireAt,
    required this.reviewStats,
    required this.recentReviews,
    required this.isReviewGiven,
    required this.jobPostCount,
  });

  factory EmployeeDetailsResult.fromJson(Map<String, dynamic> json) {
    return EmployeeDetailsResult(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      city: json['city'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      bio: json['bio'] ?? '',
      profileImage: json['profileImage'],
      skills: json['skills'] != null
          ? List<String>.from(json['skills'].map((x) => x.toString()))
          : [],
      availabilityStart: json['availabilityStart'],
      availabilityEnd: json['availabilityEnd'],
      cv: json['cv'],
      contactPerson: json['contactPerson'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isSubscribed: json['isSubscribed'],
      subscriptionExpireAt: json['subscriptionExpireAt'],
      reviewStats: ReviewStats.fromJson(json['reviewStats'] ?? {}),
      recentReviews: json['recentReviews'] != null
          ? List<RecentReview>.from(
              json['recentReviews'].map((x) => RecentReview.fromJson(x)),
            )
          : [],
      isReviewGiven: json['isReviewGiven'] ?? false,
      jobPostCount: json['jobPostCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'fullName': fullName,
    'role': role,
    'phoneNumber': phoneNumber,
    'city': city,
    'neighborhood': neighborhood,
    'bio': bio,
    'profileImage': profileImage,
    'skills': List<dynamic>.from(skills.map((x) => x)),
    'availabilityStart': availabilityStart,
    'availabilityEnd': availabilityEnd,
    'cv': cv,
    'contactPerson': contactPerson,
    'createdAt': createdAt.toIso8601String(),
    'isSubscribed': isSubscribed,
    'subscriptionExpireAt': subscriptionExpireAt,
    'reviewStats': reviewStats.toJson(),
    'recentReviews': List<dynamic>.from(recentReviews.map((x) => x.toJson())),
    'isReviewGiven': isReviewGiven,
    'jobPostCount': jobPostCount,
  };
}

// --- Review Stats Model ---
class ReviewStats {
  final int totalReviews;
  final double averageRating;

  ReviewStats({required this.totalReviews, required this.averageRating});

  factory ReviewStats.fromJson(Map<String, dynamic> json) {
    return ReviewStats(
      totalReviews: json['totalReviews'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalReviews': totalReviews,
    'averageRating': averageRating,
  };
}

// --- Recent Review Model ---
class RecentReview {
  final String id;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final Reviewer reviewer;

  RecentReview({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.reviewer,
  });

  factory RecentReview.fromJson(Map<String, dynamic> json) {
    return RecentReview(
      id: json['id'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      reviewer: Reviewer.fromJson(json['reviewer'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'rating': rating,
    'comment': comment,
    'createdAt': createdAt.toIso8601String(),
    'reviewer': reviewer.toJson(),
  };
}

// --- Reviewer Profile Model ---
class Reviewer {
  final String id;
  final String fullName;
  final String? profileImage;

  Reviewer({required this.id, required this.fullName, this.profileImage});

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'profileImage': profileImage,
  };
}
