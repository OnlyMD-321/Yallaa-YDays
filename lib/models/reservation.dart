enum ReservationStatus { pending, confirmed, cancelled, completed }

class Reservation {
  final String id;
  final String userId;
  final String eventId;
  final String eventName;
  final String? eventDescription;
  final String? eventImage;
  final DateTime reservationDate;
  final String timeSlot;
  final ReservationStatus status;
  final double? price;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;
  final String? location;

  Reservation({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.eventName,
    this.eventDescription,
    this.eventImage,
    required this.reservationDate,
    required this.timeSlot,
    required this.status,
    this.price,
    required this.createdAt,
    this.updatedAt,
    this.notes,
    this.location,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      eventId: json['eventId'] ?? '',
      eventName: json['eventName'] ?? '',
      eventDescription: json['eventDescription'],
      eventImage: json['eventImage'],
      reservationDate: DateTime.parse(json['reservationDate']),
      timeSlot: json['timeSlot'] ?? '',
      status: _parseStatus(json['status']),
      price: json['price']?.toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      notes: json['notes'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'eventId': eventId,
      'eventName': eventName,
      'eventDescription': eventDescription,
      'eventImage': eventImage,
      'reservationDate': reservationDate.toIso8601String(),
      'timeSlot': timeSlot,
      'status': status.name,
      'price': price,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'notes': notes,
      'location': location,
    };
  }

  static ReservationStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return ReservationStatus.pending;
      case 'confirmed':
        return ReservationStatus.confirmed;
      case 'cancelled':
        return ReservationStatus.cancelled;
      case 'completed':
        return ReservationStatus.completed;
      default:
        return ReservationStatus.pending;
    }
  }

  String get statusText {
    switch (status) {
      case ReservationStatus.pending:
        return 'Pending';
      case ReservationStatus.confirmed:
        return 'Confirmed';
      case ReservationStatus.cancelled:
        return 'Cancelled';
      case ReservationStatus.completed:
        return 'Completed';
    }
  }

  bool get canCancel =>
      status == ReservationStatus.pending ||
      status == ReservationStatus.confirmed;
}
