import 'package:dio/dio.dart';
import '../models/reservation.dart';
import '../config/api_config.dart';
import 'api_client.dart';
import 'mock_data_service.dart';

class ReservationService {
  final ApiClient _apiClient = ApiClient();
  final MockDataService _mockService = MockDataService();

  // Set to true to use mock data instead of API
  static const bool useMockData = true;

  Future<List<Reservation>> getUserReservations() async {
    if (useMockData) {
      final currentUser = MockDataService.currentUser;
      if (currentUser != null) {
        return _mockService.getUserReservations(currentUser.id);
      }
      return [];
    }

    try {
      final response = await _apiClient.dio.get(
        ApiConfig.userReservationsEndpoint,
      );

      final List<dynamic> reservationsJson =
          response.data['reservations'] ?? response.data;
      return reservationsJson
          .map((json) => Reservation.fromJson(json))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('Failed to load reservations');
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while loading reservations',
      );
    }
  }

  Future<Reservation> createReservation({
    required String eventId,
    required DateTime reservationDate,
    required String timeSlot,
    String? notes,
  }) async {
    if (useMockData) {
      return _mockService.createReservation(
        eventId: eventId,
        timeSlot: timeSlot,
        reservationDate: reservationDate,
        notes: notes,
      );
    }

    try {
      final Map<String, dynamic> data = {
        'eventId': eventId,
        'reservationDate': reservationDate.toIso8601String(),
        'timeSlot': timeSlot,
        if (notes != null) 'notes': notes,
      };

      final response = await _apiClient.dio.post(
        ApiConfig.reservationsEndpoint,
        data: data,
      );

      return Reservation.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid reservation data');
      } else if (e.response?.statusCode == 409) {
        throw Exception('Time slot is no longer available');
      }
      throw Exception('Failed to create reservation');
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while creating reservation',
      );
    }
  }

  Future<Reservation> updateReservation({
    required String reservationId,
    DateTime? reservationDate,
    String? timeSlot,
    String? notes,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      if (reservationDate != null) {
        data['reservationDate'] = reservationDate.toIso8601String();
      }
      if (timeSlot != null) {
        data['timeSlot'] = timeSlot;
      }
      if (notes != null) {
        data['notes'] = notes;
      }

      final response = await _apiClient.dio.put(
        '${ApiConfig.reservationsEndpoint}/$reservationId',
        data: data,
      );

      return Reservation.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Reservation not found');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Invalid reservation data');
      } else if (e.response?.statusCode == 409) {
        throw Exception('Time slot is no longer available');
      }
      throw Exception('Failed to update reservation');
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while updating reservation',
      );
    }
  }

  Future<void> cancelReservation(String reservationId) async {
    if (useMockData) {
      final success = await _mockService.cancelReservation(reservationId);
      if (!success) {
        throw Exception('Impossible d\'annuler cette réservation');
      }
      return;
    }

    try {
      await _apiClient.dio.patch(
        '${ApiConfig.reservationsEndpoint}/$reservationId/cancel',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Reservation not found');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Cannot cancel this reservation');
      }
      throw Exception('Failed to cancel reservation');
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while canceling reservation',
      );
    }
  }

  Future<Reservation> getReservationById(String reservationId) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConfig.reservationsEndpoint}/$reservationId',
      );

      return Reservation.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Reservation not found');
      }
      throw Exception('Failed to load reservation');
    } catch (e) {
      throw Exception('An unexpected error occurred while loading reservation');
    }
  }
}
