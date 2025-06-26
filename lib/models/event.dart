class Event {
  final String id;
  final String title;
  final String description;
  final String? image;
  final double price;
  final String category;
  final List<String> tags;
  final String location;
  final String district; // Quartier in Casablanca
  final double? rating;
  final int? reviewCount;
  final String organizerId;
  final String organizerName;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> availableTimeSlots;
  final bool isActive;
  final int maxParticipants;
  final int currentParticipants;
  final bool isFree;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    required this.price,
    required this.category,
    required this.tags,
    required this.location,
    required this.district,
    this.rating,
    this.reviewCount,
    required this.organizerId,
    required this.organizerName,
    required this.startDate,
    required this.endDate,
    required this.availableTimeSlots,
    required this.isActive,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.isFree,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      location: json['location'] ?? '',
      district: json['district'] ?? '',
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
      organizerId: json['organizerId'] ?? '',
      organizerName: json['organizerName'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      availableTimeSlots: List<String>.from(json['availableTimeSlots'] ?? []),
      isActive: json['isActive'] ?? true,
      maxParticipants: json['maxParticipants'] ?? 0,
      currentParticipants: json['currentParticipants'] ?? 0,
      isFree: json['isFree'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'category': category,
      'tags': tags,
      'location': location,
      'district': district,
      'rating': rating,
      'reviewCount': reviewCount,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'availableTimeSlots': availableTimeSlots,
      'isActive': isActive,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'isFree': isFree,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get formattedPrice =>
      isFree ? 'Gratuit' : '${price.toStringAsFixed(0)} DH';

  String get ratingText => rating != null
      ? '${rating!.toStringAsFixed(1)} (${reviewCount ?? 0} avis)'
      : 'Pas encore d\'avis';

  String get participantsText =>
      '$currentParticipants/$maxParticipants participants';

  bool get isAvailable => currentParticipants < maxParticipants && isActive;

  String get statusText {
    if (!isActive) return 'Inactif';
    if (currentParticipants >= maxParticipants) return 'Complet';
    if (endDate.isBefore(DateTime.now())) return 'Terminé';
    if (startDate.isAfter(DateTime.now())) return 'À venir';
    return 'En cours';
  }

  String get dateRange {
    if (startDate.day == endDate.day &&
        startDate.month == endDate.month &&
        startDate.year == endDate.year) {
      return _formatDate(startDate);
    }
    return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc',
    ];

    return '${date.day} ${months[date.month - 1]}';
  }
}
