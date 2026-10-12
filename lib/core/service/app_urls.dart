class AppUrls {
  AppUrls._();

  /// Local base url
  //static const String _baseURL = "http://10.0.20.221:6018/api/v1";

  /// VPS base url
  // ignore: unused_field
  static const String _baseURL = "http://206.162.244.143:6018/api/v1";

  /// Authentication
  static String login = "$_baseURL/auth/otp-login/request";
  static String verifyOtp = "$_baseURL/auth/otp-login/verify";
  static String employeeSignup = "$_baseURL/user/register";
  static String signupVerification = "$_baseURL/user/verify";
  static String getMe = "$_baseURL/auth/me";
  static String updateProfile = "$_baseURL/auth/me/update";

  /// Employee side
  static String getJobPosts({
    List<String>? skills,
    List<String>? city,
    List<String>? neighborhood,
    int? remunerationMin,
    int? remunerationMax,
    DateTime? visibilityStartDate,
    DateTime? visibilityEndDate,
    int page = 1,
    int limit = 10,
    String sortBy = "id",
    String sortOrder = "desc",
    String? searchTerm,
    String? urgencyLevel,
  }) {
    final Map<String, dynamic> queryParams = {};

    if (skills != null && skills.isNotEmpty) {
      queryParams['skills'] = skills.join(',');
    }
    if (city != null && city.isNotEmpty) {
      queryParams['city'] = city.join(',');
    }
    if (neighborhood != null && neighborhood.isNotEmpty) {
      queryParams['neighborhood'] = neighborhood.join(',');
    }

    if (remunerationMin != null) {
      queryParams['remunerationMin'] = remunerationMin.toString();
    }
    if (remunerationMax != null) {
      queryParams['remunerationMax'] = remunerationMax.toString();
    }

    if (visibilityStartDate != null) {
      queryParams['visibilityStartDate'] = visibilityStartDate
          .toUtc()
          .toIso8601String();
    }
    if (visibilityEndDate != null) {
      queryParams['visibilityEndDate'] = visibilityEndDate
          .toUtc()
          .toIso8601String();
    }
    queryParams['page'] = page.toString();
    queryParams['limit'] = limit.toString();
    queryParams['sortBy'] = sortBy;
    queryParams['sortOrder'] = sortOrder;

    if (searchTerm != null && searchTerm.trim().isNotEmpty) {
      queryParams['searchTerm'] = searchTerm.trim();
    }
    if (urgencyLevel != null && urgencyLevel.trim().isNotEmpty) {
      queryParams['urgencyLevel'] = urgencyLevel.trim();
    }

    final baseUri = Uri.parse("$_baseURL/job-posts");
    return baseUri.replace(queryParameters: queryParams).toString();
  }

  /// Recruiter side
  static String publishMission = "$_baseURL/job-posts";
  static String getMyMissions(int page, int limit) =>
      "$_baseURL/job-posts/my?page=$page&limit=$limit";
  static String missionDetails(String jobId) =>
      "$_baseURL/job-posts/employer-details/$jobId";
  static String updateMission(String jobId) => "$_baseURL/job-posts/$jobId";
  static String deleteMission(String jobId) => "$_baseURL/job-posts/$jobId";
  static String jobPostDetails(String jobId) =>
      "$_baseURL/job-posts/details/$jobId";
  static String applyJob(String jobId) => "$_baseURL/job-posts/$jobId/apply";
  static String cvList({Map<String, dynamic>? queryParameters}) {
    if (queryParameters == null || queryParameters.isEmpty) {
      return "$_baseURL/cv-library";
    }

    final Map<String, String> formattedQueryParams = {};

    queryParameters.forEach((key, value) {
      if (value == null) return;

      if (value is List) {
        if (value.isNotEmpty) {
          formattedQueryParams[key] = value.join(',');
        }
      } else if (value.toString().isNotEmpty) {
        formattedQueryParams[key] = value.toString();
      }
    });

    if (formattedQueryParams.isEmpty) {
      return "$_baseURL/cv-library";
    }

    final Uri uri = Uri.parse(
      "$_baseURL/cv-library",
    ).replace(queryParameters: formattedQueryParams);

    return uri.toString();
  }

  static String notifications(int page, int limit) =>
      "$_baseURL/notify/my?&page=$page&limit=$limit";
  static String markAsRead(String notificationId) =>
      "$_baseURL/notify/single/$notificationId";
  static String notificationUnreadCount() => "$_baseURL/notify/unread-count";
  static String markAllAsRead() => "$_baseURL/notify/mark-all";
  static String allUnreadNotification(String status, int page, int limit) =>
      "/notify/my?isRead=$status&page=$page&limit=$limit";

  static String userDetails(String userId, String showJobPostCount) =>
      "$_baseURL/user/$userId?showJobPostCount=$showJobPostCount";

  static String reviewsForSpecificUser(String userId, int page, int limit) =>
      "$_baseURL/user/reviews/$userId?page=$page&limit=$limit&sortOrder=desc";

  static String review() => "$_baseURL/reviews";
  static String subscription() => "$_baseURL/subscriptions";
  static String deleteAccount() => "$_baseURL/auth/delete-account";
  static String logoutAccount() => "$_baseURL/auth/logout";
}
