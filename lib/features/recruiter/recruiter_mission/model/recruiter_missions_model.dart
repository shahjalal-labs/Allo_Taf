class RecruiterMissionsModel {
  final bool? success;
  final String? message;
  final RecruiterMissionsResult? result;

  RecruiterMissionsModel({this.success, this.message, this.result});

  factory RecruiterMissionsModel.fromJson(Map<String, dynamic> json) {
    return RecruiterMissionsModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      result: json['result'] != null
          ? RecruiterMissionsResult.fromJson(
              json['result'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'result': result?.toJson()};
  }
}

class RecruiterMissionsResult {
  final MetaData? meta;
  final List<MissionItem>? data;

  RecruiterMissionsResult({this.meta, this.data});

  factory RecruiterMissionsResult.fromJson(Map<String, dynamic> json) {
    return RecruiterMissionsResult(
      meta: json['meta'] != null
          ? MetaData.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      data: json['data'] != null
          ? (json['data'] as List)
                .map((e) => MissionItem.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta?.toJson(),
      'data': data?.map((e) => e.toJson()).toList(),
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

class MissionItem {
  final String? id;
  final String? title;
  final String? urgencyLevel;
  final String? city;
  final String? neighborhood;
  final num? remuneration;
  final String? visibilityStartDate;
  final String? visibilityEndDate;
  final int? workHours;
  final String? createdAt;

  MissionItem({
    this.id,
    this.title,
    this.urgencyLevel,
    this.city,
    this.neighborhood,
    this.remuneration,
    this.visibilityStartDate,
    this.visibilityEndDate,
    this.workHours,
    this.createdAt,
  });

  factory MissionItem.fromJson(Map<String, dynamic> json) {
    return MissionItem(
      id: json['id'] as String?,
      title: json['title'] as String?,
      urgencyLevel: json['urgencyLevel'] as String?,
      city: json['city'] as String?,
      neighborhood: json['neighborhood'] as String?,
      remuneration: json['remuneration'] as num?,
      visibilityStartDate: json['visibilityStartDate'] as String?,
      visibilityEndDate: json['visibilityEndDate'] as String?,
      workHours: json['work_hours'] as int?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'urgencyLevel': urgencyLevel,
      'city': city,
      'neighborhood': neighborhood,
      'remuneration': remuneration,
      'visibilityStartDate': visibilityStartDate,
      'visibilityEndDate': visibilityEndDate,
      'work_hours': workHours,
      'createdAt': createdAt,
    };
  }
}
