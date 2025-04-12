import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification.dart';

class NotificationNotifier extends StateNotifier<List<Notification>> {
  final _supabase = Supabase.instance.client;

  NotificationNotifier() : super([]) {
    loadNotifications();
    _supabase.from('notifications').stream(primaryKey: ['id']).listen((List<Map<String, dynamic>> data) {
      state = data.map((map) => Notification.fromMap(map)).toList();
    });
  }

  Future<void> loadNotifications() async {
    final data = await _supabase.from('notifications').select();
    state = data.map((map) => Notification.fromMap(map)).toList();
  }

  Future<void> markAsRead(int id) async {
    await _supabase.from('notifications').update({'is_read': true}).eq('id', id);
    state = [
      for (final notification in state)
        notification.id == id ? notification.copyWith(isRead: true) : notification,
    ];
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, List<Notification>>((ref) {
  return NotificationNotifier();
});
