import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final _supabase = Supabase.instance.client;
  RealtimeChannel? _channel;

  NotificationNotifier() : super([]) {
    loadNotifications(1); // Profile ID 1
    _channel = _supabase.channel('notifications').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: 'INSERT', schema: 'public', table: 'notifications'),
      (payload, [ref]) => loadNotifications(1),
    ).subscribe();
  }

  Future<void> loadNotifications(int profileId) async {
    state = await _supabase.from('notifications').select().eq('profile_id', profileId).order('timestamp', ascending: false);
  }

  Future<void> addNotification(int profileId, String type, String content) async {
    await _supabase.from('notifications').insert({'profile_id': profileId, 'type': type, 'content': content});
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, List<Map<String, dynamic>>>((ref) => NotificationNotifier());
