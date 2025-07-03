import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../models/api_response.dart';
import 'storage_service.dart';

class ApiService {
  static final Dio _dio = Dio();

  static void initialize() {
    _dio.options = BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: Duration(milliseconds: AppConfig.connectionTimeoutMs),
      receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeoutMs),
      headers: {'Content-Type': 'application/json'},
    );

    // Add interceptor for auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = StorageService.getString(AppConfig.authTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            debugPrint('REQUEST: ${options.method} ${options.path}');
            debugPrint('HEADERS: ${options.headers}');
            debugPrint('DATA: ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
              'RESPONSE: ${response.statusCode} ${response.requestOptions.path}',
            );
            debugPrint('DATA: ${response.data}');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint(
              'ERROR: ${error.response?.statusCode} ${error.requestOptions.path}',
            );
            debugPrint('MESSAGE: ${error.message}');
          }
          handler.next(error);
        },
      ),
    );
  }

  // Generic GET request
  static Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        if (fromJson != null && response.data != null) {
          return ApiResponse.success(fromJson(response.data));
        } else {
          return ApiResponse.success(response.data);
        }
      } else {
        return ApiResponse.error(
          'Request failed with status: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  // Generic POST request
  static Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (fromJson != null && response.data != null) {
          return ApiResponse.success(fromJson(response.data));
        } else {
          return ApiResponse.success(response.data);
        }
      } else {
        return ApiResponse.error(
          'Request failed with status: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  // Generic PUT request
  static Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        if (fromJson != null && response.data != null) {
          return ApiResponse.success(fromJson(response.data));
        } else {
          return ApiResponse.success(response.data);
        }
      } else {
        return ApiResponse.error(
          'Request failed with status: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  // Generic PATCH request
  static Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        if (fromJson != null && response.data != null) {
          return ApiResponse.success(fromJson(response.data));
        } else {
          return ApiResponse.success(response.data);
        }
      } else {
        return ApiResponse.error(
          'Request failed with status: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  // Generic DELETE request
  static Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (fromJson != null && response.data != null) {
          return ApiResponse.success(fromJson(response.data));
        } else {
          return ApiResponse.success(response.data);
        }
      } else {
        return ApiResponse.error(
          'Request failed with status: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  // Handle Dio errors
  static ApiResponse<T> _handleDioError<T>(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiResponse.error(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.sendTimeout:
        return ApiResponse.error('Request timeout. Please try again.');
      case DioExceptionType.receiveTimeout:
        return ApiResponse.error('Response timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Request failed';
        return ApiResponse.error(message, statusCode);
      case DioExceptionType.cancel:
        return ApiResponse.error('Request cancelled.');
      case DioExceptionType.connectionError:
        return ApiResponse.error(
          'Connection error. Please check your internet connection.',
        );
      case DioExceptionType.unknown:
        return ApiResponse.error(
          'An unexpected error occurred. Please try again.',
        );
      default:
        return ApiResponse.error(
          'An unexpected error occurred. Please try again.',
        );
    }
  }

  // Upload file
  static Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?additionalData,
      });

      final response = await _dio.post(endpoint, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (fromJson != null && response.data != null) {
          return ApiResponse.success(fromJson(response.data));
        } else {
          return ApiResponse.success(response.data);
        }
      } else {
        return ApiResponse.error(
          'Upload failed with status: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  // Set auth token
  static void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Clear auth token
  static void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
