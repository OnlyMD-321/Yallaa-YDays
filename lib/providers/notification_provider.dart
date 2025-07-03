import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get hasUnreadNotifications => unreadCount > 0;

  Future<void> loadNotifications({int? limit}) async {
    _setLoading(true);
    _clearError();

    try {
      final queryParams = <String, dynamic>{if (limit != null) 'limit': limit};

      final response = await ApiService.get(
        '/notifications',
        queryParameters: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final notificationsData = response.data as List<dynamic>;

        _notifications = notificationsData
            .map(
              (json) => AppNotification.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        _setError(response.errorMessage);
      }
    } catch (e) {
      _setError('Failed to load notifications: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> markAsRead(String notificationId) async {
    try {
      final response = await ApiService.patch(
        '/notifications/$notificationId/read',
      );

      if (response.isSuccess) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = AppNotification.fromJson(
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
      _setError('Failed to mark notification as read: $e');
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      final response = await ApiService.patch('/notifications/read-all');

      if (response.isSuccess) {
        // Update all notifications to read status
        _notifications = _notifications.map((notification) {
          return AppNotification.fromJson({
            ...notification.toJson(),
            'isRead': true,
          });
        }).toList();

        notifyListeners();
        return true;
      } else {
        _setError(response.errorMessage);
        return false;
      }
    } catch (e) {
      _setError('Failed to mark all notifications as read: $e');
      return false;
    }
  }

  Future<bool> deleteNotification(String notificationId) async {
    try {
      final response = await ApiService.delete(
        '/notifications/$notificationId',
      );

      if (response.isSuccess) {
        _notifications.removeWhere((n) => n.id == notificationId);
        notifyListeners();
        return true;
      } else {
        _setError(response.errorMessage);
        return false;
      }
    } catch (e) {
      _setError('Failed to delete notification: $e');
      return false;
    }
  }

  Future<bool> sendNotification(NotificationRequest request) async {
    try {
      final response = await ApiService.post(
        '/notifications/send',
        data: request.toJson(),
      );

      if (response.isSuccess) {
        // Show local notification
        await NotificationService.showNotification(
          id: DateTime.now().millisecondsSinceEpoch,
          title: request.title,
          body: request.body,
          payload: request.data?.toString(),
        );

        return true;
      } else {
        _setError(response.errorMessage);
        return false;
      }
    } catch (e) {
      _setError('Failed to send notification: $e');
      return false;
    }
  }

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();

    // Show local notification
    NotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: notification.title,
      body: notification.body,
      payload: notification.data?.toString(),
    );
  }

  List<AppNotification> get unreadNotifications {
    return _notifications.where((n) => !n.isRead).toList();
  }

  List<AppNotification> get readNotifications {
    return _notifications.where((n) => n.isRead).toList();
  }

  List<AppNotification> getNotificationsByType(String type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
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
