import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mime/mime.dart';

import '../response_data.dart';
import 'auth_service.dart';
import 'logger.dart';

class NetworkCaller {
  final int timeoutDuration = 100;

  Uri _parseUrl(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'http://$url';
    }
    return Uri.parse(url);
  }

  Future<ResponseData> getRequest(String endpoint, {String? token}) async {
    AppLoggerHelper.info('GET Request: $endpoint');
    try {
      final Response response = await get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? '${AuthService.token}',
          'Content-type': 'application/json',
        },
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> postRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    AppLoggerHelper.info('POST Request: $endpoint');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body.toString())}');

    try {
      final Response response = await post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? '${AuthService.token}',
          'Content-type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> postImageRequest(
    String url, {
    required File file,
    required String token,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = token;
    request.files.add(
      await http.MultipartFile.fromPath('pickImage', file.path),
    );

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    return ResponseData(
      statusCode: response.statusCode,
      isSuccess: response.statusCode == 201,
      responseData: jsonDecode(responseData),
      errorMessage: "",
    );
  }

  Future<ResponseData> putRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    AppLoggerHelper.info('PUT Request: $endpoint');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body.toString())}');

    try {
      final Response response = await put(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? '${AuthService.token}',
          'Content-type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> patchRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    AppLoggerHelper.info('PATCH Request: $endpoint');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body.toString())}');

    try {
      final Response response = await patch(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? '${AuthService.token}',
          'Content-type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> deleteRequest(
    String endpoint,
    String? token, {
    Map<String, dynamic>? body,
  }) async {
    AppLoggerHelper.info('DELETE Request: $endpoint');
    try {
      final Response response = await delete(
        Uri.parse(endpoint),
        headers: {
          'Authorization': token ?? '${AuthService.token}',
          'Content-type': 'application/json',
        },
        body: body != null ? jsonEncode(body) : null,
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Single file PATCH multipart
  Future<ResponseData> patchMultipart(
    String url, {
    required String fileField,
    required File file,
    String? token,
  }) async {
    try {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final mimeTypeSplit = mimeType.split('/');

      var request = http.MultipartRequest('PATCH', Uri.parse(url));

      if (token != null) {
        request.headers['Authorization'] = token;
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          fileField,
          file.path,
          contentType: MediaType(mimeTypeSplit[0], mimeTypeSplit[1]),
        ),
      );

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      return _handleResponse(response);
    } catch (e) {
      log("patchMultipart error: ${e.toString()}");
      return _handleError(e);
    }
  }

  /// PATCH multipart with multiple files + extra text fields
  Future<ResponseData> patchMultipartMultipleFiles(
    String url, {
    required String fileField,
    required List<File> files,
    Map<String, String>? extraFields,
    String? token,
  }) async {
    try {
      var request = http.MultipartRequest('PATCH', Uri.parse(url));

      final String authHeader = '$token';
      log('patchMultipartMultipleFiles token raw: $token');
      log('patchMultipartMultipleFiles auth header: $authHeader');

      request.headers['Authorization'] = authHeader;

      if (extraFields != null) {
        request.fields.addAll(extraFields);
        log('patchMultipartMultipleFiles fields: $extraFields');
      }

      for (final File file in files) {
        final String? mimeType = lookupMimeType(file.path);
        final MediaType? contentType = mimeType != null
            ? MediaType.parse(mimeType)
            : null;
        log(
          'patchMultipartMultipleFiles adding file: ${file.path}, mime: $mimeType',
        );

        final multipartFile = await http.MultipartFile.fromPath(
          fileField,
          file.path,
          contentType: contentType,
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log('patchMultipartMultipleFiles status: ${response.statusCode}');
      log('patchMultipartMultipleFiles body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      log('patchMultipartMultipleFiles error: $e');
      return _handleError(e);
    }
  }

  /// Generic multipart request with JSON bodyData field + optional files
  Future<ResponseData> multipartJsonRequest({
    required String url,
    required String method,
    required Map<String, dynamic> bodyData,
    Map<String, dynamic>? files,
    String? token,
    String jsonFieldName = 'bodyData',
  }) async {
    try {
      final parsedUrl = _parseUrl(url);
      final request = http.MultipartRequest(method, parsedUrl);

      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = token; // ← fixed
      }

      request.fields[jsonFieldName] = jsonEncode(bodyData);

      if (files != null) {
        for (final entry in files.entries) {
          final key = entry.key;
          final value = entry.value;

          if (value == null) continue;

          if (value is File) {
            final mimeType =
                lookupMimeType(value.path) ?? 'application/octet-stream';
            final parts = mimeType.split('/');

            request.files.add(
              await http.MultipartFile.fromPath(
                key,
                value.path,
                contentType: MediaType(parts[0], parts[1]),
              ),
            );
          } else if (value is List<File>) {
            for (final file in value) {
              final mimeType =
                  lookupMimeType(file.path) ?? 'application/octet-stream';
              final parts = mimeType.split('/');

              request.files.add(
                await http.MultipartFile.fromPath(
                  key,
                  file.path,
                  contentType: MediaType(parts[0], parts[1]),
                ),
              );
            }
          }
        }
      }

      log('multipartJsonRequest bodyData: ${jsonEncode(bodyData)}');
      log('multipartJsonRequest files: ${files.toString()}');

      final streamedResponse = await request.send().timeout(
        Duration(seconds: timeoutDuration),
      );

      final response = await http.Response.fromStream(
        streamedResponse,
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ─── Response & Error Handlers ────────────────────────────────────────────

  Future<ResponseData> _handleResponse(http.Response response) async {
    AppLoggerHelper.info('Response Status: ${response.statusCode}');
    AppLoggerHelper.info('Response Body: ${response.body}');

    dynamic decodedResponse;
    try {
      if (response.body.isNotEmpty) {
        decodedResponse = jsonDecode(response.body);
      } else {
        decodedResponse = null;
      }
    } catch (e) {
      decodedResponse = response.body;
    }

    final int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
      case 201:
        return ResponseData(
          isSuccess: true,
          statusCode: statusCode,
          errorMessage: '',
          responseData: decodedResponse,
        );

      case 204:
        return ResponseData(
          isSuccess: true,
          statusCode: statusCode,
          errorMessage: '',
          responseData: null,
        );

      case 400:
      case 401:
      case 403:
      case 404:
      case 409:
      case 422:
      case 429:
      case 500:
      case 503:
        return ResponseData(
          isSuccess: false,
          statusCode: statusCode,
          errorMessage: _getFallbackErrorMessage(statusCode),
          responseData: decodedResponse,
        );

      default:
        return ResponseData(
          isSuccess: false,
          statusCode: statusCode,
          errorMessage: 'An unexpected error occurred.',
          responseData: decodedResponse,
        );
    }
  }

  String _getFallbackErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Access forbidden.';
      case 404:
        return 'Resource not found.';
      case 409:
        return 'Conflict occurred.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Something went wrong.';
    }
  }

  ResponseData _handleError(dynamic error) {
    log('Request Error: $error');

    if (error is TimeoutException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        errorMessage:
            'Request timed out. Please check your internet connection and try again.',
        responseData: null,
      );
    } else if (error is http.ClientException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage:
            'Network error occurred. Please check your connection and try again.',
        responseData: null,
      );
    } else {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Unexpected error occurred. Please try again later.',
        responseData: null,
      );
    }
  }
}
