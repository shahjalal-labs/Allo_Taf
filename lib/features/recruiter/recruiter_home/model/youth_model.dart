// import 'package:flutter/foundation.dart';
// import 'review_model.dart';
//
// @immutable
// class YouthModel {
//   final String id;
//   final String name;
//   final String location;
//   final String role;
//   final double rating;
//   final int reviewsCount;
//   final String avatarUrl;
//   final bool isVerified;
//   final bool isAvailableToday;
//   final bool hasCv;
//   final List<ReviewModel> reviews ;
//
//   const YouthModel({
//     required this.id,
//     required this.name,
//     required this.location,
//     required this.role,
//     required this.rating,
//     required this.reviewsCount,
//     required this.avatarUrl,
//     this.isVerified = true,
//     this.isAvailableToday = true,
//     this.hasCv = true,
//     this.reviews = const [],
//   });
//
//   factory YouthModel.fromJson(Map<String, dynamic> json) {
//     return YouthModel(
//       id: json['id']?.toString() ?? '',
//       name: json['name']?.toString() ?? '',
//       location: json['location']?.toString() ?? '',
//       role: json['role']?.toString() ?? '',
//       rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
//       reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
//       avatarUrl: json['avatarUrl']?.toString() ?? '',
//       isVerified: json['isVerified'] as bool? ?? true,
//       isAvailableToday: json['isAvailableToday'] as bool? ?? true,
//       hasCv: json['hasCv'] as bool? ?? true,
//       reviews: json['reviews'] != null
//           ? (json['reviews'] as List)
//           .map((reviewJson) => ReviewModel.fromJson(reviewJson))
//           .toList()
//           : [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'location': location,
//       'role': role,
//       'rating': rating,
//       'reviewsCount': reviewsCount,
//       'avatarUrl': avatarUrl,
//       'isVerified': isVerified,
//       'isAvailableToday': isAvailableToday,
//       'hasCv': hasCv,
//       'reviews': reviews.map((review) => review.toJson()).toList(),
//     };
//   }
//
//   @override
//   String toString() {
//     return 'YouthModel(id: $id, name: $name, location: $location, role: $role, rating: $rating, reviewsCount: $reviewsCount, isVerified: $isVerified, isAvailableToday: $isAvailableToday, hasCv: $hasCv, reviewsCount: ${reviews.length})';
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//
//     return other is YouthModel &&
//         other.id == id &&
//         other.name == name &&
//         other.location == location &&
//         other.role == role &&
//         other.rating == rating &&
//         other.reviewsCount == reviewsCount &&
//         other.avatarUrl == avatarUrl &&
//         other.isVerified == isVerified &&
//         other.isAvailableToday == isAvailableToday &&
//         other.hasCv == hasCv &&
//         listEquals(other.reviews, reviews);
//   }
//
//   @override
//   int get hashCode {
//     return id.hashCode ^
//     name.hashCode ^
//     location.hashCode ^
//     role.hashCode ^
//     rating.hashCode ^
//     reviewsCount.hashCode ^
//     avatarUrl.hashCode ^
//     isVerified.hashCode ^
//     isAvailableToday.hashCode ^
//     hasCv.hashCode ^
//     reviews.hashCode;
//   }
// }
