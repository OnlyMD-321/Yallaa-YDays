class AppConfig {
  // API Configuration
  static const String baseUrl = 'http://localhost:3000/api';
  static const String socketUrl = 'http://localhost:3000';

  // App Information
  static const String appName = 'Yallaa';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String favoritesKey = 'favorites';
  static const String notificationsKey = 'notifications';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxRetries = 3;

  // Timeouts
  static const int connectionTimeoutMs = 30000;
  static const int receiveTimeoutMs = 30000;

  // Stripe Configuration
  static const String stripePublishableKey =
      'pk_test_...'; // Replace with actual key

  // Map Configuration
  static const double defaultLatitude = 33.5731;
  static const double defaultLongitude = -7.5898; // Casablanca coordinates
  static const double defaultZoom = 12.0;

  // Image Configuration
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> supportedImageTypes = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
}
