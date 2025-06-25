class ApiConfig {
  static const String baseUrl = 'https://yallaa-api.casablanca.ma/api';

  // Auth endpoints
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String logoutEndpoint = '$baseUrl/auth/logout';
  static const String refreshTokenEndpoint = '$baseUrl/auth/refresh';
  static const String registerEndpoint = '$baseUrl/auth/register';

  // Events endpoints (renamed from services)
  static const String eventsEndpoint = '$baseUrl/events';
  static const String searchEventsEndpoint = '$baseUrl/events/search';
  static const String categoriesEndpoint = '$baseUrl/events/categories';
  static const String districtsEndpoint = '$baseUrl/events/districts';
  static const String featuredEventsEndpoint = '$baseUrl/events/featured';
  static const String nearbyEventsEndpoint = '$baseUrl/events/nearby';

  // Reservations endpoints
  static const String reservationsEndpoint = '$baseUrl/reservations';
  static const String userReservationsEndpoint = '$baseUrl/reservations/user';

  // User endpoints
  static const String userProfileEndpoint = '$baseUrl/user/profile';
  static const String favoritesEndpoint = '$baseUrl/user/favorites';

  // Business endpoints (for B2B)
  static const String businessEndpoint = '$baseUrl/business';
  static const String organizersEndpoint = '$baseUrl/organizers';
  static const String restaurantsEndpoint = '$baseUrl/restaurants';

  // Request timeout
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Casablanca districts
  static const List<String> casablancaDistricts = [
    'Maarif',
    'Gauthier',
    'Racine',
    'Anfa',
    'Bourgogne',
    'Palmier',
    'Oasis',
    'Californie',
    'Maârif Extension',
    'Hay Hassani',
    'Sidi Bernoussi',
    'Ain Sebaa',
    'Mohammedia',
    'Hay Moulay Rachid',
    'Casablanca Centre',
  ];

  // Event categories
  static const List<String> eventCategories = [
    'Restaurants',
    'Événements',
    'Sports',
    'Culture',
    'Nightlife',
    'Shopping',
    'Éducation',
    'Santé & Bien-être',
    'Technologie',
    'Art & Divertissement',
  ];
}
