import 'user.dart';
import 'listing.dart';

class Booking {
  final String id;
  final String listingId;
  final String userId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final String currency;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Listing? listing;
  final User? user;

  Booking({
    required this.id,
    required this.listingId,
    required this.userId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.currency,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.listing,
    this.user,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      listingId: json['listingId'] as String,
      userId: json['userId'] as String,
      checkIn: DateTime.parse(json['checkIn'] as String),
      checkOut: DateTime.parse(json['checkOut'] as String),
      guests: json['guests'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      currency: json['currency'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      listing: json['listing'] != null
          ? Listing.fromJson(json['listing'] as Map<String, dynamic>)
          : null,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listingId': listingId,
      'userId': userId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guests': guests,
      'totalPrice': totalPrice,
      'currency': currency,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'listing': listing?.toJson(),
      'user': user?.toJson(),
    };
  }

  String get totalPriceFormatted => '$totalPrice $currency';
  Duration get duration => checkOut.difference(checkIn);
  int get nights => duration.inDays;
  bool get isActive => status == 'CONFIRMED' || status == 'CHECKED_IN';
  bool get isPending => status == 'PENDING';
  bool get isCancelled => status == 'CANCELLED';
  bool get isCompleted => status == 'COMPLETED';
}

class BookingAvailability {
  final DateTime date;
  final bool isAvailable;
  final double? price;
  final int? maxGuests;

  BookingAvailability({
    required this.date,
    required this.isAvailable,
    this.price,
    this.maxGuests,
  });

  factory BookingAvailability.fromJson(Map<String, dynamic> json) {
    return BookingAvailability(
      date: DateTime.parse(json['date'] as String),
      isAvailable: json['isAvailable'] as bool,
      price: (json['price'] as num?)?.toDouble(),
      maxGuests: json['maxGuests'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'isAvailable': isAvailable,
      'price': price,
      'maxGuests': maxGuests,
    };
  }
}

class BookingRequest {
  final String listingId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final String? notes;

  BookingRequest({
    required this.listingId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'listingId': listingId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guests': guests,
      'notes': notes,
    };
  }
}
