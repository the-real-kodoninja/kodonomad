import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/event.dart';

class EventNotifier extends StateNotifier<List<Event>> {
  final _supabase = Supabase.instance.client;

  EventNotifier() : super([]) {
    loadEvents();
  }

  Future<void> loadEvents() async {
    final data = await _supabase.from('events').select('*, profiles(username)').order('start_time', ascending: true);
    state = data.map((map) => Event.fromMap(map)).toList();
  }

  Future<void> createEvent(Event event) async {
    final newEventMap = await _supabase.from('events').insert(event.toMap()).select().single();
    final newEvent = Event.fromMap(newEventMap);
    state = [...state, newEvent];
  }

  Future<void> joinEvent(int eventId, int profileId) async {
    await _supabase.from('event_participants').insert({
      'event_id': eventId,
      'profile_id': profileId,
      'joined_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<int>> getParticipants(int eventId) async {
    final data = await _supabase.from('event_participants').select('profile_id').eq('event_id', eventId);
    return data.map((map) => map['profile_id'] as int).toList();
  }
}

final eventProvider = StateNotifierProvider<EventNotifier, List<Event>>((ref) {
  return EventNotifier();
});
