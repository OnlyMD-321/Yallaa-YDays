class SearchFilters {
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final String? location;
  final List<String> tags;
  final String? sortBy;
  final bool sortAscending;

  SearchFilters({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.location,
    this.tags = const [],
    this.sortBy,
    this.sortAscending = true,
  });

  SearchFilters copyWith({
    String? category,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? location,
    List<String>? tags,
    String? sortBy,
    bool? sortAscending,
  }) {
    return SearchFilters(
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      location: location ?? this.location,
      tags: tags ?? this.tags,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'minRating': minRating,
      'location': location,
      'tags': tags,
      'sortBy': sortBy,
      'sortAscending': sortAscending,
    };
  }

  factory SearchFilters.fromJson(Map<String, dynamic> json) {
    return SearchFilters(
      category: json['category'],
      minPrice: json['minPrice']?.toDouble(),
      maxPrice: json['maxPrice']?.toDouble(),
      minRating: json['minRating']?.toDouble(),
      location: json['location'],
      tags: List<String>.from(json['tags'] ?? []),
      sortBy: json['sortBy'],
      sortAscending: json['sortAscending'] ?? true,
    );
  }

  bool get hasActiveFilters {
    return category != null ||
        minPrice != null ||
        maxPrice != null ||
        minRating != null ||
        location != null ||
        tags.isNotEmpty ||
        sortBy != null;
  }

  SearchFilters clear() {
    return SearchFilters();
  }
}
