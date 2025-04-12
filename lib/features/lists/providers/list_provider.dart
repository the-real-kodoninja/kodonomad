import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListNotifier extends StateNotifier<Map<int, List<Map<String, dynamic>>>> {
  final _supabase = Supabase.instance.client;

  ListNotifier() : super({}) {
    loadLists();
  }

  Future<void> loadLists() async {
    final data = await _supabase.from('lists').select('*, profiles(username)');
    final listsMap = <int, List<Map<String, dynamic>>>{};
    for (var list in data) {
      final profileId = list['profile_id'] as int;
      listsMap[profileId] = [...(listsMap[profileId] ?? []), list];
    }
    state = listsMap;
  }

  Future<void> createList(int profileId, String name) async {
    final newList = await _supabase.from('lists').insert({
      'profile_id': profileId,
      'name': name,
      'created_at': DateTime.now().toIso8601String(),
    }).select().single();
    state = {
      ...state,
      profileId: [...(state[profileId] ?? []), newList],
    };
  }

  Future<void> addToList(int listId, int profileId) async {
    await _supabase.from('list_members').insert({
      'list_id': listId,
      'profile_id': profileId,
      'added_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<int>> getListMembers(int listId) async {
    final data = await _supabase.from('list_members').select('profile_id').eq('list_id', listId);
    return data.map((map) => map['profile_id'] as int).toList();
  }
}

final listProvider = StateNotifierProvider<ListNotifier, Map<int, List<Map<String, dynamic>>>>((ref) {
  return ListNotifier();
});
