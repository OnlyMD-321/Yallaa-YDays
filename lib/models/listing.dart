import 'user.dart';

class Listing {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String location;
  final double latitude;
  final double longitude;
  final String categoryId;
  final String partnerId;
  final List<String> images;
  final List<String> amenities;
  final int maxGuests;
  final bool isActive;
  final double averageRating;
  final int totalReviews;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category? category;
  final User? partner;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.categoryId,
    required this.partnerId,
    required this.images,
    required this.amenities,
    required this.maxGuests,
    required this.isActive,
    required this.averageRating,
    required this.totalReviews,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.partner,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      location: json['location'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      partnerId: json['partnerId'] as String,
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      maxGuests: json['maxGuests'] as int,
      isActive: json['isActive'] as bool,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      category: json['category'] != null
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      partner: json['partner'] != null
          ? User.fromJson(json['partner'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'currency': currency,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'categoryId': categoryId,
      'partnerId': partnerId,
      'images': images,
      'amenities': amenities,
      'maxGuests': maxGuests,
      'isActive': isActive,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'category': category?.toJson(),
      'partner': partner?.toJson(),
    };
  }

  String get priceFormatted => '$price $currency';
  String get firstImage => images.isNotEmpty ? images.first : '';
  bool get hasImages => images.isNotEmpty;
}

class Category {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Amenity {
  final String id;
  final String name;
  final String? icon;
  final String? category;
  final bool isActive;

  Amenity({
    required this.id,
    required this.name,
    this.icon,
    this.category,
    required this.isActive,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      category: json['category'] as String?,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'category': category,
      'isActive': isActive,
    };
  }
}
