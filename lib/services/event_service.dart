import 'package:dio/dio.dart';
import '../models/event.dart';
import '../models/search_filters.dart';
import '../config/api_config.dart';
import 'api_client.dart';
import 'mock_data_service.dart';

class EventService {
  final ApiClient _apiClient = ApiClient();
  final MockDataService _mockService = MockDataService();

  // Set to true to use mock data instead of API
  static const bool useMockData = true;

  Future<List<Event>> getAllEvents() async {
    if (useMockData) {
      return _mockService.getAllEvents();
    }

    try {
      final response = await _apiClient.dio.get(ApiConfig.eventsEndpoint);

      final List<dynamic> eventsJson = response.data['events'] ?? response.data;
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('Failed to load events');
    } catch (e) {
      throw Exception('An unexpected error occurred while loading events');
    }
  }

  Future<List<Event>> searchEvents({
    String? query,
    SearchFilters? filters,
  }) async {
    if (useMockData) {
      return _mockService.searchEvents(
        query: query,
        filters: filters ?? SearchFilters(),
      );
    }

    try {
      final Map<String, dynamic> queryParams = {};

      if (query != null && query.isNotEmpty) {
        queryParams['q'] = query;
      }

      if (filters != null) {
        if (filters.category != null) {
          queryParams['category'] = filters.category;
        }
        if (filters.minPrice != null) {
          queryParams['minPrice'] = filters.minPrice;
        }
        if (filters.maxPrice != null) {
          queryParams['maxPrice'] = filters.maxPrice;
        }
        if (filters.minRating != null) {
          queryParams['minRating'] = filters.minRating;
        }
        if (filters.location != null) {
          queryParams['location'] = filters.location;
        }
        if (filters.tags.isNotEmpty) {
          queryParams['tags'] = filters.tags.join(',');
        }
        if (filters.sortBy != null) {
          queryParams['sortBy'] = filters.sortBy;
          queryParams['sortOrder'] = filters.sortAscending ? 'asc' : 'desc';
        }
      }

      final response = await _apiClient.dio.get(
        ApiConfig.searchEventsEndpoint,
        queryParameters: queryParams,
      );

      final List<dynamic> eventsJson = response.data['events'] ?? response.data;
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('Failed to search events');
    } catch (e) {
      throw Exception('An unexpected error occurred while searching events');
    }
  }

  Future<Event> getEventById(String eventId) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConfig.eventsEndpoint}/$eventId',
      );

      return Event.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Event not found');
      }
      throw Exception('Failed to load event details');
    } catch (e) {
      throw Exception('An unexpected error occurred while loading event');
    }
  }

  Future<List<String>> getCategories() async {
    if (useMockData) {
      return _mockService.getCategories();
    }

    try {
      final response = await _apiClient.dio.get(ApiConfig.categoriesEndpoint);

      final List<dynamic> categoriesJson =
          response.data['categories'] ?? response.data;
      return categoriesJson.cast<String>();
    } on DioException {
      // Return default categories if API fails
      return ApiConfig.eventCategories;
    } catch (e) {
      return ApiConfig.eventCategories;
    }
  }

  Future<List<String>> getDistricts() async {
    if (useMockData) {
      return _mockService.getDistricts();
    }

    try {
      final response = await _apiClient.dio.get(ApiConfig.districtsEndpoint);

      final List<dynamic> districtsJson =
          response.data['districts'] ?? response.data;
      return districtsJson.cast<String>();
    } on DioException {
      // Return default districts if API fails
      return ApiConfig.casablancaDistricts;
    } catch (e) {
      return ApiConfig.casablancaDistricts;
    }
  }

  Future<List<Event>> getFeaturedEvents() async {
    try {
      final response = await _apiClient.dio.get(
        ApiConfig.featuredEventsEndpoint,
      );

      final List<dynamic> eventsJson = response.data['events'] ?? response.data;
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('Failed to load featured events');
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while loading featured events',
      );
    }
  }

  Future<List<Event>> getNearbyEvents({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConfig.nearbyEventsEndpoint,
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
          'radius': radiusKm,
        },
      );

      final List<dynamic> eventsJson = response.data['events'] ?? response.data;
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('Failed to load nearby events');
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while loading nearby events',
      );
    }
  }

  Future<void> addToFavorites(String eventId) async {
    try {
      await _apiClient.dio.post('${ApiConfig.favoritesEndpoint}/$eventId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Event not found');
      }
      throw Exception('Failed to add to favorites');
    } catch (e) {
      throw Exception('An unexpected error occurred while adding to favorites');
    }
  }

  Future<void> removeFromFavorites(String eventId) async {
    try {
      await _apiClient.dio.delete('${ApiConfig.favoritesEndpoint}/$eventId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Event not found');
      }
      throw Exception('Failed to remove from favorites');
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while removing from favorites',
      );
    }
  }

  Future<List<Event>> getFavoriteEvents() async {
    try {
      final response = await _apiClient.dio.get(ApiConfig.favoritesEndpoint);

      final List<dynamic> eventsJson = response.data['events'] ?? response.data;
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('Failed to load favorite events');
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while loading favorite events',
      );
    }
  }
}
