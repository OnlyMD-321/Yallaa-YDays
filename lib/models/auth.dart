import 'user.dart';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class LoginResponse {
  final String token;
  final User user;
  final bool success;
  final String? message;

  LoginResponse({
    required this.token,
    required this.user,
    required this.success,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      success: json['success'] ?? false,
      message: json['message'],
    );
  }
}
