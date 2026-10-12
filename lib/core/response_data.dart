class ResponseData {
  final bool isSuccess;
  final int statusCode;
  final String errorMessage;
  final dynamic responseData;

  const ResponseData({
    required this.isSuccess,
    required this.statusCode,
    required this.errorMessage,
    required this.responseData,
  });

  /// Returns the best available human-readable message.
  /// Priority: server 'message' field → errorMessage → generic fallback
  String get displayMessage {
    if (responseData != null && responseData is Map) {
      final serverMessage = responseData['message'];
      if (serverMessage != null && serverMessage.toString().trim().isNotEmpty) {
        return serverMessage.toString();
      }
    }
    if (errorMessage.trim().isNotEmpty) {
      return errorMessage;
    }
    return 'Something went wrong. Please try again.';
  }

  bool get isTimeout => statusCode == 408;
  bool get isServerError => statusCode >= 500;
  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() =>
      'ResponseData(isSuccess: $isSuccess, statusCode: $statusCode, '
      'errorMessage: $errorMessage, responseData: $responseData)';
}
