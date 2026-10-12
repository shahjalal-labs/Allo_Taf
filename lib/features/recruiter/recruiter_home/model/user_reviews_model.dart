import 'dart:convert';

/// Helper functions for parsing raw JSON string
UserReviewsModel userReviewsModelFromJson(String str) =>
    UserReviewsModel.fromJson(json.decode(str));

String userReviewsModelToJson(UserReviewsModel data) =>
    json.encode(data.toJson());

// --- Main Root Model ---
class UserReviewsModel {
  final bool success;
  final String message;
  final UserReviewsResult result;

  UserReviewsModel({
    required this.success,
    required this.message,
    required this.result,
  });

  factory UserReviewsModel.fromJson(Map<String, dynamic> json) {
    return UserReviewsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      result: UserReviewsResult.fromJson(json['result'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'result': result.toJson(),
  };
}

// --- Reviews Result Container (Meta + Data) ---
class UserReviewsResult {
  final ReviewMeta meta;
  final List<ReviewData> data;

  UserReviewsResult({required this.meta, required this.data});

  factory UserReviewsResult.fromJson(Map<String, dynamic> json) {
    return UserReviewsResult(
      meta: ReviewMeta.fromJson(json['meta'] ?? {}),
      data: json['data'] != null
          ? List<ReviewData>.from(
              json['data'].map((x) => ReviewData.fromJson(x)),
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
class ReviewMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  ReviewMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory ReviewMeta.fromJson(Map<String, dynamic> json) {
    return ReviewMeta(
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

// --- Individual Review Item Model ---
class ReviewData {
  final String id;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final ReviewerInfo reviewer;

  ReviewData({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.reviewer,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      id: json['id'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      reviewer: ReviewerInfo.fromJson(json['reviewer'] ?? {}),
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
class ReviewerInfo {
  final String id;
  final String fullName;
  final String? profileImage;

  ReviewerInfo({required this.id, required this.fullName, this.profileImage});

  factory ReviewerInfo.fromJson(Map<String, dynamic> json) {
    return ReviewerInfo(
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
