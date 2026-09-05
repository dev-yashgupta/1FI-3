import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';

/// Typed exception thrown by the data layer.
/// Carries the HTTP status code and a human-readable message.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Singleton Dio HTTP client — all API calls go through here.
class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.addAll([
      // Log requests in debug mode only
      if (kDebugMode)
        LogInterceptor(
          request: true,
          requestBody: false,
          responseBody: false,
          responseHeader: false,
          error: true,
          logPrint: (obj) => debugPrint('[API] $obj'),
        ),
      _ApiErrorInterceptor(),
    ]);

  /// GET request — returns the parsed response data.
  Future<T> get<T>(String path, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get<T>(path, queryParameters: params);
      if (response.data == null) {
        throw const ApiException('Empty response from server');
      }
      return response.data as T;
    } on DioException catch (e) {
      throw _toDomainException(e);
    }
  }

  /// Convert a DioException to an ApiException with a readable message.
  static ApiException _toDomainException(DioException e) {
    final statusCode = e.response?.statusCode;

    // Try to extract the message from the Express error shape:
    // { "error": { "message": "..." } }
    String? serverMessage;
    try {
      final data = e.response?.data;
      if (data is Map) {
        serverMessage = (data['error'] as Map?)?['message'] as String?
            ?? data['message'] as String?;
      }
    } catch (_) {}

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const ApiException(
        'Request timed out. Check your connection.',
        statusCode: null,
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return ApiException(
        'Cannot reach the server. Make sure the backend is running at ${AppConstants.apiBaseUrl}',
        statusCode: null,
      );
    }

    return ApiException(
      serverMessage ?? e.message ?? 'Unexpected error occurred.',
      statusCode: statusCode,
    );
  }
}

/// Forwards Dio errors without swallowing them — actual conversion
/// happens in ApiClient._toDomainException per call-site.
class _ApiErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
