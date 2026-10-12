import 'dart:convert';

/// Helper function to parse raw JSON response string
NotificationResponseModel notificationResponseFromJson(String str) =>
    NotificationResponseModel.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponseModel data) =>
    json.encode(data.toJson());

class NotificationResponseModel {
  final bool? success;
  final String? message;
  final NotificationResult? result;

  NotificationResponseModel({this.success, this.message, this.result});

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      result: json['result'] != null
          ? NotificationResult.fromJson(json['result'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'result': result?.toJson(),
  };
}

class NotificationResult {
  final NotificationMeta? meta;
  final List<NotificationItem>? data;

  NotificationResult({this.meta, this.data});

  factory NotificationResult.fromJson(Map<String, dynamic> json) {
    return NotificationResult(
      meta: json['meta'] != null
          ? NotificationMeta.fromJson(json['meta'])
          : null,
      data: json['data'] != null
          ? (json['data'] as List)
                .map((e) => NotificationItem.fromJson(e))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'meta': meta?.toJson(),
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class NotificationMeta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  NotificationMeta({this.page, this.limit, this.total, this.totalPages});

  factory NotificationMeta.fromJson(Map<String, dynamic> json) {
    return NotificationMeta(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      total: json['total'] as int?,
      totalPages: json['totalPages'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'total': total,
    'totalPages': totalPages,
  };
}

class NotificationItem {
  final String? id;
  final String? title;
  final String? body;
  final bool? isRead;
  final String? type;
  final String? notificationChannel;
  final NotificationMetaData? metaData;
  final String? sender;
  final DateTime? createdAt;

  NotificationItem({
    this.id,
    this.title,
    this.body,
    this.isRead,
    this.type,
    this.notificationChannel,
    this.metaData,
    this.sender,
    this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      isRead: json['isRead'] as bool?,
      type: json['type'] as String?,
      notificationChannel: json['notificationChannel'] as String?,
      metaData: json['metaData'] != null
          ? NotificationMetaData.fromJson(json['metaData'])
          : null,
      sender: json['sender'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'isRead': isRead,
    'type': type,
    'notificationChannel': notificationChannel,
    'metaData': metaData?.toJson(),
    'sender': sender,
    'createdAt': createdAt?.toIso8601String(),
  };
}

class NotificationMetaData {
  final String? action;
  final String? actionId;
  final NotificationExtra? extra;
  final String? messagePreview;

  NotificationMetaData({
    this.action,
    this.actionId,
    this.extra,
    this.messagePreview,
  });

  factory NotificationMetaData.fromJson(Map<String, dynamic> json) {
    return NotificationMetaData(
      action: json['action'] as String?,
      actionId: json['actionId'] as String?,
      extra: json['extra'] != null
          ? NotificationExtra.fromJson(json['extra'])
          : null,
      messagePreview: json['messagePreview'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'action': action,
    'actionId': actionId,
    'extra': extra?.toJson(),
    'messagePreview': messagePreview,
  };
}

class NotificationExtra {
  final String? deeplink;
  final String? priority;
  final String? sound;

  NotificationExtra({this.deeplink, this.priority, this.sound});

  factory NotificationExtra.fromJson(Map<String, dynamic> json) {
    return NotificationExtra(
      deeplink: json['deeplink'] as String?,
      priority: json['priority'] as String?,
      sound: json['sound'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'deeplink': deeplink,
    'priority': priority,
    'sound': sound,
  };
}
