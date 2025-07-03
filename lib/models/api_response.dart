class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse._({
    required this.isSuccess,
    this.data,
    this.message,
    this.statusCode,
  });

  // Success response
  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse._(isSuccess: true, data: data, message: message);
  }

  // Error response
  factory ApiResponse.error(String message, [int? statusCode]) {
    return ApiResponse._(
      isSuccess: false,
      message: message,
      statusCode: statusCode,
    );
  }

  // Check if response is successful
  bool get isError => !isSuccess;

  // Get error message
  String get errorMessage => message ?? 'Unknown error occurred';

  @override
  String toString() {
    return 'ApiResponse{isSuccess: $isSuccess, data: $data, message: $message, statusCode: $statusCode}';
  }
}
