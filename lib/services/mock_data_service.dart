import '../models/event.dart';
import '../models/reservation.dart';
import '../models/user.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Mock user data
  static User? _currentUser;
  static User? get currentUser => _currentUser;
  static void setCurrentUser(User user) {
    _currentUser = user;
  }

  // Mock users for testing
  static final List<User> _mockUsers = [
    User(
      id: 'user1',
      email: 'mohamed@example.com',
      firstName: 'Mohamed',
      lastName: 'Alami',
      phone: '+212 6 12 34 56 78',
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    User(
      id: 'user2',
      email: 'fatima@example.com',
      firstName: 'Fatima',
      lastName: 'Benali',
      phone: '+212 6 87 65 43 21',
      createdAt: DateTime.now().subtract(const Duration(days: 80)),
    ),
    User(
      id: 'user3',
      email: 'youssef@example.com',
      firstName: 'Youssef',
      lastName: 'Tadili',
      phone: '+212 6 11 22 33 44',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    User(
      id: 'admin',
      email: 'admin@yallaa.ma',
      firstName: 'Admin',
      lastName: 'Yallaa',
      phone: '+212 5 22 00 00 00',
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
    ),
  ];

  // Mock passwords (in a real app, these would be hashed)
  static final Map<String, String> _mockPasswords = {
    'mohamed@example.com': '123456',
    'fatima@example.com': 'password',
    'youssef@example.com': 'youssef123',
    'admin@yallaa.ma': 'admin123',
  };

  // Mock events data
  static final List<Event> _mockEvents = [
    Event(
      id: '1',
      title: 'Festival de Musique Gnawa',
      description:
          'Un festival authentique de musique Gnawa dans le cœur de Casablanca avec des artistes renommés.',
      image:
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
      price: 150.0,
      category: 'Musique',
      tags: ['Musique', 'Culture', 'Gnawa', 'Festival'],
      location: 'Place Mohammed V',
      district: 'Centre-ville',
      rating: 4.8,
      reviewCount: 125,
      organizerId: 'org1',
      organizerName: 'Casa Events',
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 9)),
      availableTimeSlots: ['19:00-23:00', '20:00-00:00'],
      isActive: true,
      maxParticipants: 500,
      currentParticipants: 320,
      isFree: false,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Event(
      id: '2',
      title: 'Cours de Cuisine Marocaine',
      description:
          'Apprenez à préparer les plats traditionnels marocains avec un chef expérimenté.',
      image: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400',
      price: 200.0,
      category: 'Gastronomie',
      tags: ['Cuisine', 'Apprentissage', 'Traditionnel'],
      location: 'École Culinaire Atlas',
      district: 'Maarif',
      rating: 4.9,
      reviewCount: 89,
      organizerId: 'org2',
      organizerName: 'Chef Amina',
      startDate: DateTime.now().add(const Duration(days: 3)),
      endDate: DateTime.now().add(const Duration(days: 3, hours: 4)),
      availableTimeSlots: ['10:00-14:00', '15:00-19:00'],
      isActive: true,
      maxParticipants: 12,
      currentParticipants: 8,
      isFree: false,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Event(
      id: '3',
      title: 'Tour Guidé de la Medina',
      description:
          'Découvrez les secrets de la vieille médina de Casablanca avec un guide local.',
      image:
          'https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e?w=400',
      price: 0.0,
      category: 'Tourisme',
      tags: ['Visite', 'Culture', 'Histoire', 'Gratuit'],
      location: 'Ancienne Médina',
      district: 'Ancienne Médina',
      rating: 4.5,
      reviewCount: 203,
      organizerId: 'org3',
      organizerName: 'Guides Casa',
      startDate: DateTime.now().add(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 1, hours: 3)),
      availableTimeSlots: ['09:00-12:00', '14:00-17:00'],
      isActive: true,
      maxParticipants: 25,
      currentParticipants: 15,
      isFree: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Event(
      id: '4',
      title: 'Soirée Cinéma en Plein Air',
      description:
          'Projection de films marocains et internationaux sous les étoiles.',
      image:
          'https://images.unsplash.com/photo-1489185988761-132206b7d5d3?w=400',
      price: 50.0,
      category: 'Cinéma',
      tags: ['Cinéma', 'Plein air', 'Films'],
      location: 'Parc de la Ligue Arabe',
      district: 'Maarif',
      rating: 4.3,
      reviewCount: 156,
      organizerId: 'org4',
      organizerName: 'Ciné Casa',
      startDate: DateTime.now().add(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 5, hours: 3)),
      availableTimeSlots: ['20:00-23:00'],
      isActive: true,
      maxParticipants: 200,
      currentParticipants: 85,
      isFree: false,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    Event(
      id: '5',
      title: 'Atelier d\'Artisanat Berbère',
      description:
          'Créez vos propres bijoux et objets décoratifs dans la tradition berbère.',
      image:
          'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=400',
      price: 120.0,
      category: 'Artisanat',
      tags: ['Artisanat', 'Berbère', 'Créativité'],
      location: 'Centre Culturel Sidi Belyout',
      district: 'Sidi Belyout',
      rating: 4.7,
      reviewCount: 67,
      organizerId: 'org5',
      organizerName: 'Artisans du Maroc',
      startDate: DateTime.now().add(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 10, hours: 6)),
      availableTimeSlots: ['09:00-12:00', '14:00-17:00'],
      isActive: true,
      maxParticipants: 15,
      currentParticipants: 12,
      isFree: false,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Event(
      id: '6',
      title: 'Match de Football Local',
      description:
          'Supportez l\'équipe locale de Casablanca dans ce match passionnant.',
      image:
          'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=400',
      price: 80.0,
      category: 'Sport',
      tags: ['Football', 'Sport', 'Local'],
      location: 'Stade Mohammed V',
      district: 'Racine',
      rating: 4.1,
      reviewCount: 245,
      organizerId: 'org6',
      organizerName: 'Casa Sports',
      startDate: DateTime.now().add(const Duration(days: 14)),
      endDate: DateTime.now().add(const Duration(days: 14, hours: 2)),
      availableTimeSlots: ['16:00-18:00'],
      isActive: true,
      maxParticipants: 1000,
      currentParticipants: 650,
      isFree: false,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
  ];

  // Mock reservations data
  static final List<Reservation> _mockReservations = [
    Reservation(
      id: 'res1',
      userId: 'user1',
      eventId: '1',
      eventName: 'Festival de Musique Gnawa',
      eventDescription:
          'Un festival authentique de musique Gnawa dans le cœur de Casablanca.',
      eventImage:
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
      reservationDate: DateTime.now().add(const Duration(days: 7)),
      timeSlot: '19:00-23:00',
      status: ReservationStatus.confirmed,
      price: 150.0,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      location: 'Place Mohammed V',
      notes: 'Réservation pour 2 personnes',
    ),
    Reservation(
      id: 'res2',
      userId: 'user1',
      eventId: '2',
      eventName: 'Cours de Cuisine Marocaine',
      eventDescription:
          'Apprenez à préparer les plats traditionnels marocains.',
      eventImage:
          'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400',
      reservationDate: DateTime.now().add(const Duration(days: 3)),
      timeSlot: '10:00-14:00',
      status: ReservationStatus.pending,
      price: 200.0,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      location: 'École Culinaire Atlas',
    ),
    Reservation(
      id: 'res3',
      userId: 'user1',
      eventId: '3',
      eventName: 'Tour Guidé de la Medina',
      eventDescription:
          'Découvrez les secrets de la vieille médina de Casablanca.',
      eventImage:
          'https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e?w=400',
      reservationDate: DateTime.now().subtract(const Duration(days: 5)),
      timeSlot: '09:00-12:00',
      status: ReservationStatus.completed,
      price: 0.0,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      location: 'Ancienne Médina',
      notes: 'Excellente expérience!',
    ),
  ];

  // Categories and districts
  static final List<String> _categories = [
    'Musique',
    'Gastronomie',
    'Tourisme',
    'Cinéma',
    'Artisanat',
    'Sport',
    'Culture',
    'Art',
    'Éducation',
    'Bien-être',
  ];

  static final List<String> _districts = [
    'Centre-ville',
    'Maarif',
    'Ancienne Médina',
    'Sidi Belyout',
    'Racine',
    'Ain Diab',
    'Bourgogne',
    'Gauthier',
    'Palmier',
    'Anfa',
  ];

  // Getters for mock data
  List<Event> get events => List.unmodifiable(_mockEvents);
  List<Reservation> get reservations =>
      _mockReservations.where((r) => r.userId == currentUser?.id).toList();
  List<String> get categories => List.unmodifiable(_categories);
  List<String> get districts => List.unmodifiable(_districts);

  // Mock methods
  Future<List<Event>> getAllEvents() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return events;
  }

  Future<List<Event>> searchEvents({String? query, required filters}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    List<Event> filteredEvents = events;

    if (query != null && query.isNotEmpty) {
      filteredEvents = filteredEvents.where((event) {
        return event.title.toLowerCase().contains(query.toLowerCase()) ||
            event.description.toLowerCase().contains(query.toLowerCase()) ||
            event.category.toLowerCase().contains(query.toLowerCase()) ||
            event.tags.any(
              (tag) => tag.toLowerCase().contains(query.toLowerCase()),
            );
      }).toList();
    }

    // Apply filters
    if (filters.category != null && filters.category!.isNotEmpty) {
      filteredEvents = filteredEvents
          .where((event) => event.category == filters.category)
          .toList();
    }

    if (filters.location != null && filters.location!.isNotEmpty) {
      filteredEvents = filteredEvents
          .where((event) => event.district == filters.location)
          .toList();
    }

    if (filters.minPrice != null) {
      filteredEvents = filteredEvents
          .where((event) => event.price >= filters.minPrice!)
          .toList();
    }

    if (filters.maxPrice != null) {
      filteredEvents = filteredEvents
          .where((event) => event.price <= filters.maxPrice!)
          .toList();
    }

    if (filters.minRating != null) {
      filteredEvents = filteredEvents
          .where(
            (event) =>
                event.rating != null && event.rating! >= filters.minRating!,
          )
          .toList();
    }

    if (filters.isFree == true) {
      filteredEvents = filteredEvents.where((event) => event.isFree).toList();
    }

    return filteredEvents;
  }

  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return categories;
  }

  Future<List<String>> getDistricts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return districts;
  }

  Future<List<Reservation>> getUserReservations(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockReservations.where((r) => r.userId == userId).toList();
  }

  Future<Reservation> createReservation({
    required String eventId,
    required String timeSlot,
    required DateTime reservationDate,
    String? notes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final event = _mockEvents.firstWhere((e) => e.id == eventId);
    final reservation = Reservation(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      userId: currentUser!.id,
      eventId: eventId,
      eventName: event.title,
      eventDescription: event.description,
      eventImage: event.image,
      reservationDate: reservationDate,
      timeSlot: timeSlot,
      status: ReservationStatus.pending,
      price: event.price,
      createdAt: DateTime.now(),
      location: event.location,
      notes: notes,
    );

    _mockReservations.add(reservation);
    return reservation;
  }

  Future<bool> cancelReservation(String reservationId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _mockReservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      final reservation = _mockReservations[index];
      final updatedReservation = Reservation(
        id: reservation.id,
        userId: reservation.userId,
        eventId: reservation.eventId,
        eventName: reservation.eventName,
        eventDescription: reservation.eventDescription,
        eventImage: reservation.eventImage,
        reservationDate: reservation.reservationDate,
        timeSlot: reservation.timeSlot,
        status: ReservationStatus.cancelled,
        price: reservation.price,
        createdAt: reservation.createdAt,
        updatedAt: DateTime.now(),
        location: reservation.location,
        notes: reservation.notes,
      );
      _mockReservations[index] = updatedReservation;
      return true;
    }
    return false;
  }

  // Mock login
  // Mock login with predefined users
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Normalize email
    final normalizedEmail = email.toLowerCase().trim();

    // Check if user exists and password matches
    if (_mockPasswords.containsKey(normalizedEmail)) {
      final expectedPassword = _mockPasswords[normalizedEmail]!;

      if (password == expectedPassword) {
        final user = _mockUsers.firstWhere(
          (u) => u.email.toLowerCase() == normalizedEmail,
        );
        setCurrentUser(user);
        return user;
      }
    }

    throw Exception('Email ou mot de passe incorrect');
  }

  // Get available mock users for testing
  List<Map<String, String>> getMockUserCredentials() {
    return [
      {
        'email': 'mohamed@example.com',
        'password': '123456',
        'name': 'Mohamed Alami',
      },
      {
        'email': 'fatima@example.com',
        'password': 'password',
        'name': 'Fatima Benali',
      },
      {
        'email': 'youssef@example.com',
        'password': 'youssef123',
        'name': 'Youssef Tadili',
      },
      {
        'email': 'admin@yallaa.ma',
        'password': 'admin123',
        'name': 'Admin Yallaa',
      },
    ];
  }

  // Mock logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }
}
