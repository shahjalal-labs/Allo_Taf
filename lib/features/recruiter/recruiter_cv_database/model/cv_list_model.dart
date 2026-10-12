import 'dart:convert';

/// Helper function to parse raw JSON string
CvListResponse cvListResponseFromJson(String str) =>
    CvListResponse.fromJson(json.decode(str));

String cvListResponseToJson(CvListResponse data) => json.encode(data.toJson());

// --- Main API Response Model ---
class CvListResponse {
  final bool success;
  final String message;
  final CvListResult result;

  CvListResponse({
    required this.success,
    required this.message,
    required this.result,
  });

  factory CvListResponse.fromJson(Map<String, dynamic> json) {
    return CvListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      result: CvListResult.fromJson(json['result'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'result': result.toJson(),
  };
}

// --- Result Payload Model ---
class CvListResult {
  final PageMeta meta;
  final List<CandidateProfile> data;

  CvListResult({required this.meta, required this.data});

  factory CvListResult.fromJson(Map<String, dynamic> json) {
    return CvListResult(
      meta: PageMeta.fromJson(json['meta'] ?? {}),
      data: json['data'] != null
          ? List<CandidateProfile>.from(
              json['data'].map((x) => CandidateProfile.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'meta': meta.toJson(),
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

// --- Pagination Metadata Model ---
class PageMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PageMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PageMeta.fromJson(Map<String, dynamic> json) {
    return PageMeta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'total': total,
    'totalPages': totalPages,
  };
}

// --- Candidate Profile Model ---
class CandidateProfile {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String profileImage;
  final String bio;
  final List<String> skills;
  final String city;
  final String neighborhood;
  final String? availabilityStart;
  final String? availabilityEnd;
  final String cv;
  final bool? isSubscribed;
  final String? subscriptionExpireAt;
  final DateTime createdAt;
  final ReviewStats reviewStats;

  CandidateProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.bio,
    required this.skills,
    required this.city,
    required this.neighborhood,
    this.availabilityStart,
    this.availabilityEnd,
    required this.cv,
    this.isSubscribed,
    this.subscriptionExpireAt,
    required this.createdAt,
    required this.reviewStats,
  });

  factory CandidateProfile.fromJson(Map<String, dynamic> json) {
    return CandidateProfile(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImage: json['profileImage'] ?? '',
      bio: json['bio'] ?? '',
      skills: json['skills'] != null
          ? List<String>.from(json['skills'].map((x) => x.toString()))
          : [],
      city: json['city'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      availabilityStart: json['availabilityStart'],
      availabilityEnd: json['availabilityEnd'],
      cv: json['cv'] ?? '',
      isSubscribed: json['isSubscribed'],
      subscriptionExpireAt: json['subscriptionExpireAt'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      reviewStats: ReviewStats.fromJson(json['reviewStats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'profileImage': profileImage,
    'bio': bio,
    'skills': List<dynamic>.from(skills.map((x) => x)),
    'city': city,
    'neighborhood': neighborhood,
    'availabilityStart': availabilityStart,
    'availabilityEnd': availabilityEnd,
    'cv': cv,
    'isSubscribed': isSubscribed,
    'subscriptionExpireAt': subscriptionExpireAt,
    'createdAt': createdAt.toIso8601String(),
    'reviewStats': reviewStats.toJson(),
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
