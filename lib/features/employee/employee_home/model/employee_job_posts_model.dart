class EmployeeJobPostsModel {
  final bool? success;
  final String? message;
  final JobPostsResult? result;

  EmployeeJobPostsModel({this.success, this.message, this.result});

  factory EmployeeJobPostsModel.fromJson(Map<String, dynamic> json) {
    return EmployeeJobPostsModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      result: json['result'] != null
          ? JobPostsResult.fromJson(json['result'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'result': result?.toJson()};
  }
}

class JobPostsResult {
  final MetaData? meta;
  final List<JobPostData>? data;

  JobPostsResult({this.meta, this.data});

  factory JobPostsResult.fromJson(Map<String, dynamic> json) {
    return JobPostsResult(
      meta: json['meta'] != null
          ? MetaData.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      data: json['data'] != null
          ? (json['data'] as List)
                .map(
                  (item) => JobPostData.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta?.toJson(),
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class MetaData {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  MetaData({this.page, this.limit, this.total, this.totalPages});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      total: json['total'] as int?,
      totalPages: json['totalPages'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
    };
  }
}

class JobPostData {
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
  final bool? isApplied;
  final String? applicationStatus;

  JobPostData({
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
    this.isApplied,
    this.applicationStatus,
  });

  factory JobPostData.fromJson(Map<String, dynamic> json) {
    return JobPostData(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      skills: json['skills'] != null
          ? List<String>.from(json['skills'] as List)
          : [],
      visibilityStartDate: json['visibilityStartDate'] as String?,
      visibilityEndDate: json['visibilityEndDate'] as String?,
      city: json['city'] as String?,
      neighborhood: json['neighborhood'] as String?,
      remuneration: json['remuneration'] as num?,
      whatsApp: json['whatsApp'] as String?,
      businessName: json['businessName'] as String?,
      urgencyLevel: json['urgencyLevel'] as String?,
      workHours: json['work_hours'] as int?,
      employerId: json['employerId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      isApplied: json['isApplied'] as bool?,
      applicationStatus: json['applicationStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'skills': skills,
      'visibilityStartDate': visibilityStartDate,
      'visibilityEndDate': visibilityEndDate,
      'city': city,
      'neighborhood': neighborhood,
      'remuneration': remuneration,
      'whatsApp': whatsApp,
      'businessName': businessName,
      'urgencyLevel': urgencyLevel,
      'work_hours': workHours,
      'employerId': employerId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isApplied': isApplied,
      'applicationStatus': applicationStatus,
    };
  }
}
