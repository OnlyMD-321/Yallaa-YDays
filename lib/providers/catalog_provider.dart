import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../config/app_config.dart';

class CatalogProvider with ChangeNotifier {
  List<Listing> _listings = [];
  List<Listing> _personalizedFeed = [];
  List<Category> _categories = [];
  List<Amenity> _amenities = [];
  List<String> _favorites = [];
  bool _isLoading = false;
  bool _isFeedLoading = false;
  String? _error;
  String? _searchQuery;
  String? _selectedCategoryId;
  int _currentPage = 1;
  bool _hasMoreData = true;

  List<Listing> get listings => _listings;
  List<Listing> get personalizedFeed => _personalizedFeed;
  List<Category> get categories => _categories;
  List<Amenity> get amenities => _amenities;
  List<String> get favorites => _favorites;
  bool get isLoading => _isLoading;
  bool get isFeedLoading => _isFeedLoading;
  String? get error => _error;
  String? get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;
  bool get hasMoreData => _hasMoreData;

  CatalogProvider() {
    _loadFavorites();
    loadCategories();
    loadAmenities();
  }

  void _loadFavorites() {
    _favorites = StorageService.getStringList(AppConfig.favoritesKey) ?? [];
    notifyListeners();
  }

  Future<void> loadListings({
    bool refresh = false,
    String? search,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    int? maxGuests,
    List<String>? amenities,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasMoreData = true;
      _listings.clear();
    }

    if (!_hasMoreData) return;

    _setLoading(true);
    _clearError();

    try {
      final queryParams = <String, dynamic>{
        'page': _currentPage,
        'limit': AppConfig.defaultPageSize,
        if (search != null) 'search': search,
        if (categoryId != null) 'categoryId': categoryId,
        if (minPrice != null) 'minPrice': minPrice,
        if (maxPrice != null) 'maxPrice': maxPrice,
        if (maxGuests != null) 'maxGuests': maxGuests,
        if (amenities != null) 'amenities': amenities.join(','),
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (radius != null) 'radius': radius,
      };

      final response = await ApiService.get(
        '/catalog/listings',
        queryParameters: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final listingsData = data['listings'] as List<dynamic>;

        final newListings = listingsData
            .map((json) => Listing.fromJson(json as Map<String, dynamic>))
            .toList();

        if (refresh) {
          _listings = newListings;
        } else {
          _listings.addAll(newListings);
        }

        _hasMoreData = newListings.length == AppConfig.defaultPageSize;
        _currentPage++;

        _searchQuery = search;
        _selectedCategoryId = categoryId;
      } else {
        _setError(response.errorMessage);
      }
    } catch (e) {
      _setError('Failed to load listings: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<Listing?> getListingById(String id) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.get('/catalog/listings/$id');

      if (response.isSuccess && response.data != null) {
        return Listing.fromJson(response.data as Map<String, dynamic>);
      } else {
        _setError(response.errorMessage);
        return null;
      }
    } catch (e) {
      _setError('Failed to load listing: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadPersonalizedFeed({bool refresh = false}) async {
    if (refresh) {
      _personalizedFeed.clear();
    }

    _setFeedLoading(true);
    _clearError();

    try {
      final response = await ApiService.get(
        '/catalog/feed',
        queryParameters: {'limit': AppConfig.defaultPageSize},
      );

      if (response.isSuccess && response.data != null) {
        final listingsData = response.data as List<dynamic>;

        _personalizedFeed = listingsData
            .map((json) => Listing.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        _setError(response.errorMessage);
      }
    } catch (e) {
      _setError('Failed to load personalized feed: $e');
    } finally {
      _setFeedLoading(false);
    }
  }

  Future<void> loadCategories() async {
    try {
      final response = await ApiService.get('/catalog/categories');

      if (response.isSuccess && response.data != null) {
        final categoriesData = response.data as List<dynamic>;

        _categories = categoriesData
            .map((json) => Category.fromJson(json as Map<String, dynamic>))
            .toList();

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load categories: $e');
    }
  }

  Future<void> loadAmenities() async {
    try {
      final response = await ApiService.get('/catalog/amenities');

      if (response.isSuccess && response.data != null) {
        final amenitiesData = response.data as List<dynamic>;

        _amenities = amenitiesData
            .map((json) => Amenity.fromJson(json as Map<String, dynamic>))
            .toList();

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load amenities: $e');
    }
  }

  Future<void> addToFavorites(String listingId) async {
    try {
      final response = await ApiService.post('/catalog/favorites/$listingId');

      if (response.isSuccess) {
        _favorites.add(listingId);
        await StorageService.setStringList(AppConfig.favoritesKey, _favorites);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to add to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String listingId) async {
    try {
      final response = await ApiService.delete('/catalog/favorites/$listingId');

      if (response.isSuccess) {
        _favorites.remove(listingId);
        await StorageService.setStringList(AppConfig.favoritesKey, _favorites);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to remove from favorites: $e');
    }
  }

  bool isFavorite(String listingId) {
    return _favorites.contains(listingId);
  }

  void toggleFavorite(String listingId) {
    if (isFavorite(listingId)) {
      removeFromFavorites(listingId);
    } else {
      addToFavorites(listingId);
    }
  }

  void clearSearch() {
    _searchQuery = null;
    _selectedCategoryId = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setFeedLoading(bool loading) {
    _isFeedLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
