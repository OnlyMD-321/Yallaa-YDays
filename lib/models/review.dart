import 'user.dart';
import 'listing.dart';

class Review {
  final String id;
  final String bookingId;
  final String userId;
  final String listingId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;
  final Listing? listing;

  Review({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.listingId,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.listing,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      userId: json['userId'] as String,
      listingId: json['listingId'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      listing: json['listing'] != null
          ? Listing.fromJson(json['listing'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'userId': userId,
      'listingId': listingId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'user': user?.toJson(),
      'listing': listing?.toJson(),
    };
  }

  String get ratingText {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Not Rated';
    }
  }
}

class ReviewRequest {
  final String bookingId;
  final int rating;
  final String? comment;

  ReviewRequest({required this.bookingId, required this.rating, this.comment});

  Map<String, dynamic> toJson() {
    return {'bookingId': bookingId, 'rating': rating, 'comment': comment};
  }
}
