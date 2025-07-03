import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/api_service.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];
  List<BookingAvailability> _availability = [];
  bool _isLoading = false;
  bool _isCreating = false;
  String? _error;

  List<Booking> get bookings => _bookings;
  List<BookingAvailability> get availability => _availability;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  String? get error => _error;

  Future<void> loadBookings({String? status, int? limit}) async {
    _setLoading(true);
    _clearError();

    try {
      final queryParams = <String, dynamic>{
        if (status != null) 'status': status,
        if (limit != null) 'limit': limit,
      };

      final response = await ApiService.get(
        '/booking/reservations',
        queryParameters: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final bookingsData = response.data as List<dynamic>;

        _bookings = bookingsData
            .map((json) => Booking.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        _setError(response.errorMessage);
      }
    } catch (e) {
      _setError('Failed to load bookings: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<Booking?> getBookingById(String id) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.get('/booking/reservations/$id');

      if (response.isSuccess && response.data != null) {
        return Booking.fromJson(response.data as Map<String, dynamic>);
      } else {
        _setError(response.errorMessage);
        return null;
      }
    } catch (e) {
      _setError('Failed to load booking: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkAvailability({
    required String listingId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.get(
        '/booking/availability',
        queryParameters: {
          'listingId': listingId,
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final availabilityData = response.data as List<dynamic>;

        _availability = availabilityData
            .map(
              (json) =>
                  BookingAvailability.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        _setError(response.errorMessage);
      }
    } catch (e) {
      _setError('Failed to check availability: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<Booking?> createBooking(BookingRequest request) async {
    _setCreating(true);
    _clearError();

    try {
      final response = await ApiService.post(
        '/booking/reservations',
        data: request.toJson(),
      );

      if (response.isSuccess && response.data != null) {
        final booking = Booking.fromJson(response.data as Map<String, dynamic>);
        _bookings.insert(0, booking);
        notifyListeners();
        return booking;
      } else {
        _setError(response.errorMessage);
        return null;
      }
    } catch (e) {
      _setError('Failed to create booking: $e');
      return null;
    } finally {
      _setCreating(false);
    }
  }

  Future<bool> updateBooking({
    required String id,
    DateTime? checkIn,
    DateTime? checkOut,
    int? guests,
    String? notes,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.patch(
        '/booking/reservations/$id',
        data: {
          if (checkIn != null) 'checkIn': checkIn.toIso8601String(),
          if (checkOut != null) 'checkOut': checkOut.toIso8601String(),
          if (guests != null) 'guests': guests,
          if (notes != null) 'notes': notes,
        },
      );

      if (response.isSuccess && response.data != null) {
        final updatedBooking = Booking.fromJson(
          response.data as Map<String, dynamic>,
        );

        final index = _bookings.indexWhere((b) => b.id == id);
        if (index != -1) {
          _bookings[index] = updatedBooking;
          notifyListeners();
        }

        return true;
      } else {
        _setError(response.errorMessage);
        return false;
      }
    } catch (e) {
      _setError('Failed to update booking: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> cancelBooking(String id) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.patch(
        '/booking/reservations/$id/cancel',
      );

      if (response.isSuccess) {
        final index = _bookings.indexWhere((b) => b.id == id);
        if (index != -1) {
          _bookings[index] = Booking.fromJson(
            response.data as Map<String, dynamic>,
          );
          notifyListeners();
        }

        return true;
      } else {
        _setError(response.errorMessage);
        return false;
      }
    } catch (e) {
      _setError('Failed to cancel booking: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> payForBooking({
    required String id,
    required String paymentMethodId,
    double? amount,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.post(
        '/booking/reservations/$id/pay',
        data: {
          'paymentMethodId': paymentMethodId,
          if (amount != null) 'amount': amount,
        },
      );

      if (response.isSuccess) {
        final index = _bookings.indexWhere((b) => b.id == id);
        if (index != -1) {
          _bookings[index] = Booking.fromJson(
            response.data as Map<String, dynamic>,
          );
          notifyListeners();
        }

        return true;
      } else {
        _setError(response.errorMessage);
        return false;
      }
    } catch (e) {
      _setError('Failed to process payment: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  List<Booking> get upcomingBookings {
    return _bookings
        .where(
          (booking) =>
              booking.checkIn.isAfter(DateTime.now()) && booking.isActive,
        )
        .toList()
      ..sort((a, b) => a.checkIn.compareTo(b.checkIn));
  }

  List<Booking> get pastBookings {
    return _bookings
        .where(
          (booking) =>
              booking.checkOut.isBefore(DateTime.now()) || booking.isCompleted,
        )
        .toList()
      ..sort((a, b) => b.checkOut.compareTo(a.checkOut));
  }

  List<Booking> get activeBookings {
    final now = DateTime.now();
    return _bookings
        .where(
          (booking) =>
              booking.checkIn.isBefore(now) &&
              booking.checkOut.isAfter(now) &&
              booking.isActive,
        )
        .toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setCreating(bool creating) {
    _isCreating = creating;
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
