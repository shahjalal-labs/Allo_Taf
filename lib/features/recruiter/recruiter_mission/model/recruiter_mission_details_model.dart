class ReviewStats {
  final int? totalReviews;
  final num? averageRating;

  ReviewStats({this.totalReviews, this.averageRating});

  factory ReviewStats.fromJson(Map<String, dynamic>? json) {
    return ReviewStats(
      totalReviews: json?['totalReviews'] as int?,
      averageRating: json?['averageRating'] as num?,
    );
  }
}

class ApplicantUser {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? profileImage;
  final List<String>? skills;
  final List<String>? designation;
  final String? city;
  final String? neighborhood;
  final String? bio;
  final String? cv;
  final ReviewStats? reviewStats;

  ApplicantUser({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.profileImage,
    this.skills,
    this.designation,
    this.city,
    this.neighborhood,
    this.bio,
    this.cv,
    this.reviewStats,
  });

  factory ApplicantUser.fromJson(Map<String, dynamic>? json) {
    return ApplicantUser(
      id: json?['id'] as String?,
      fullName: json?['fullName'] as String?,
      email: json?['email'] as String?,
      phoneNumber: json?['phoneNumber'] as String?,
      profileImage: json?['profileImage'] as String?,
      skills: (json?['skills'] as List?)?.map((e) => e.toString()).toList(),
      designation: (json?['designation'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      city: json?['city'] as String?,
      neighborhood: json?['neighborhood'] as String?,
      bio: json?['bio'] as String?,
      cv: json?['cv'] as String?,
      reviewStats: json?['reviewStats'] != null
          ? ReviewStats.fromJson(json?['reviewStats'] as Map<String, dynamic>?)
          : null,
    );
  }
}

class RecentApplicant {
  final String? id;
  final String? status;
  final String? appliedAt;
  final String? applicantId;
  final ApplicantUser? applicant;

  RecentApplicant({
    this.id,
    this.status,
    this.appliedAt,
    this.applicantId,
    this.applicant,
  });

  factory RecentApplicant.fromJson(Map<String, dynamic>? json) {
    return RecentApplicant(
      id: json?['id'] as String?,
      status: json?['status'] as String?,
      appliedAt: json?['appliedAt'] as String?,
      applicantId: json?['applicantId'] as String?,
      applicant: json?['applicant'] != null
          ? ApplicantUser.fromJson(json?['applicant'] as Map<String, dynamic>?)
          : null,
    );
  }
}

class JobInfo {
  final String? id;
  final String? title;
  final String? description;
  final List<String>? skills;
  final String? visibilityStartDate;
  final String? visibilityEndDate;
  final String? city;
  final String? neighborhood;
  final num? remuneration;
  final String? whatsApp;
  final String? businessName;
  final String? urgencyLevel;
  final int? workHours;
  final String? employerId;
  final String? createdAt;
  final String? updatedAt;

  JobInfo({
    this.id,
    this.title,
    this.description,
    this.skills,
    this.visibilityStartDate,
    this.visibilityEndDate,
    this.city,
    this.neighborhood,
    this.remuneration,
    this.whatsApp,
    this.businessName,
    this.urgencyLevel,
    this.workHours,
    this.employerId,
    this.createdAt,
    this.updatedAt,
  });

  factory JobInfo.fromJson(Map<String, dynamic>? json) {
    return JobInfo(
      id: json?['id'] as String?,
      title: json?['title'] as String?,
      description: json?['description'] as String?,
      skills: (json?['skills'] as List?)?.map((e) => e.toString()).toList(),
      visibilityStartDate: json?['visibilityStartDate'] as String?,
      visibilityEndDate: json?['visibilityEndDate'] as String?,
      city: json?['city'] as String?,
      neighborhood: json?['neighborhood'] as String?,
      remuneration: json?['remuneration'] as num?,
      whatsApp: json?['whatsApp'] as String?,
      businessName: json?['businessName'] as String?,
      urgencyLevel: json?['urgencyLevel'] as String?,
      workHours: json?['work_hours'] as int?,
      employerId: json?['employerId'] as String?,
      createdAt: json?['createdAt'] as String?,
      updatedAt: json?['updatedAt'] as String?,
    );
  }
}

class RecruiterJobDetailResult {
  final JobInfo? job;
  final int? applicantCount;
  final List<RecentApplicant>? recentApplicants;

  RecruiterJobDetailResult({
    this.job,
    this.applicantCount,
    this.recentApplicants,
  });

  factory RecruiterJobDetailResult.fromJson(Map<String, dynamic>? json) {
    return RecruiterJobDetailResult(
      job: json?['job'] != null
          ? JobInfo.fromJson(json?['job'] as Map<String, dynamic>?)
          : null,
      applicantCount: json?['applicantCount'] as int?,
      recentApplicants: (json?['recentApplicants'] as List?)
          ?.map((e) => RecentApplicant.fromJson(e as Map<String, dynamic>?))
          .toList(),
    );
  }
}
