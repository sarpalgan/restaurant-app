import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/models/app_notification.dart';

const _storageKey = 'app_notifications';

/// Provider for in-app notifications
final appNotificationsProvider = StateNotifierProvider<AppNotificationsNotifier, List<AppNotification>>((ref) {
  return AppNotificationsNotifier();
});

/// Provider for unread notification count
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(appNotificationsProvider);
  return notifications.where((n) => !n.isRead).length;
});

class AppNotificationsNotifier extends StateNotifier<List<AppNotification>> {
  AppNotificationsNotifier() : super([]) {
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        state = jsonList
            .map((json) => AppNotification.fromJson(json as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Newest first
      }
    } catch (e) {
      // If loading fails, start with empty list
      state = [];
    }
  }

  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = state.map((n) => n.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      // Ignore save errors
    }
  }

  /// Add a new notification
  Future<void> addNotification(AppNotification notification) async {
    state = [notification, ...state];
    await _saveNotifications();
  }

  /// Mark a notification as read
  Future<void> markAsRead(String id) async {
    state = state.map((n) {
      if (n.id == id) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    await _saveNotifications();
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
    await _saveNotifications();
  }

  /// Remove a notification
  Future<void> removeNotification(String id) async {
    state = state.where((n) => n.id != id).toList();
    await _saveNotifications();
  }

  /// Clear all notifications
  Future<void> clearAll() async {
    state = [];
    await _saveNotifications();
  }

  /// Get notification by ID
  AppNotification? getById(String id) {
    try {
      return state.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }
}
