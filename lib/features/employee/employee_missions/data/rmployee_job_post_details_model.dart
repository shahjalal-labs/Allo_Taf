class EmployeeJobPostDetailsModel {
  bool? success;
  String? message;
  JobPostDetails? result;

  EmployeeJobPostDetailsModel({this.success, this.message, this.result});

  factory EmployeeJobPostDetailsModel.fromJson(Map<String, dynamic> json) {
    return EmployeeJobPostDetailsModel(
      success: json['success'],
      message: json['message'],
      result: json['result'] != null
          ? JobPostDetails.fromJson(json['result'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class JobPostDetails {
  String? id;
  String? title;
  String? description;
  List<String>? skills;
  DateTime? visibilityStartDate;
  DateTime? visibilityEndDate;
  String? city;
  String? neighborhood;
  num? remuneration;
  String? whatsApp;
  String? businessName;
  String? urgencyLevel;
  num? workHours;
  String? employerId;
  DateTime? createdAt;
  DateTime? updatedAt;

  JobPostDetails({
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

  factory JobPostDetails.fromJson(Map<String, dynamic> json) {
    return JobPostDetails(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      visibilityStartDate: json['visibilityStartDate'] != null
          ? DateTime.tryParse(json['visibilityStartDate'])
          : null,
      visibilityEndDate: json['visibilityEndDate'] != null
          ? DateTime.tryParse(json['visibilityEndDate'])
          : null,
      city: json['city'],
      neighborhood: json['neighborhood'],
      remuneration: json['remuneration'],
      whatsApp: json['whatsApp'],
      businessName: json['businessName'],
      urgencyLevel: json['urgencyLevel'],
      workHours: json['work_hours'], // Maps `work_hours` from JSON safely
      employerId: json['employerId'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['skills'] = skills;
    data['visibilityStartDate'] = visibilityStartDate?.toIso8601String();
    data['visibilityEndDate'] = visibilityEndDate?.toIso8601String();
    data['city'] = city;
    data['neighborhood'] = neighborhood;
    data['remuneration'] = remuneration;
    data['whatsApp'] = whatsApp;
    data['businessName'] = businessName;
    data['urgencyLevel'] = urgencyLevel;
    data['work_hours'] = workHours;
    data['employerId'] = employerId;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    return data;
  }
}
