import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth.dart';
import '../models/user.dart';
import '../config/api_config.dart';
import 'api_client.dart';
import 'mock_data_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Set to true to use mock data instead of API
  static const bool useMockData = true;

  final ApiClient _apiClient = ApiClient();
  final MockDataService _mockService = MockDataService();

  Future<LoginResponse> login(LoginRequest request) async {
    if (useMockData) {
      try {
        final user = await _mockService.login(request.email, request.password);
        final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';

        await _saveAuthData(mockToken, user);
        _apiClient.setAuthToken(mockToken);

        return LoginResponse(
          success: true,
          token: mockToken,
          user: user,
          message: 'Connexion réussie',
        );
      } catch (e) {
        throw Exception('Identifiants incorrects');
      }
    }

    try {
      final response = await _apiClient.dio.post(
        ApiConfig.loginEndpoint,
        data: request.toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      if (loginResponse.success) {
        await _saveAuthData(loginResponse.token, loginResponse.user);
        _apiClient.setAuthToken(loginResponse.token);
      }

      return loginResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid email or password');
      } else if (e.response?.statusCode == 422) {
        throw Exception('Invalid input data');
      } else {
        throw Exception('Login failed. Please try again.');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> logout() async {
    if (useMockData) {
      await _mockService.logout();
      await _clearAuthData();
      _apiClient.removeAuthToken();
      return;
    }

    try {
      // Call logout API endpoint
      await _apiClient.dio.post(ApiConfig.logoutEndpoint);
    } catch (e) {
      // Even if API call fails, we should still clear local data
    } finally {
      await _clearAuthData();
      _apiClient.removeAuthToken();
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      // You'll need to implement JSON parsing here
      // For now, returning null
      return null;
    }
    return null;
  }

  Future<void> _saveAuthData(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, user.toJson().toString());
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  Future<void> initializeAuth() async {
    final token = await getAuthToken();
    if (token != null) {
      _apiClient.setAuthToken(token);
    }
  }
}
