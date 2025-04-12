import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchResult {
  final List<Map<String, dynamic>> profiles;
  final List<Map<String, dynamic>> posts;
  final List<Map<String, dynamic>> recommendations;
  final List<Map<String, dynamic>> lists;

  SearchResult({
    required this.profiles,
    required this.posts,
    required this.recommendations,
    required this.lists,
  });
}

class SearchNotifier extends StateNotifier<AsyncValue<SearchResult>> {
  final _supabase = Supabase.instance.client;

  SearchNotifier() : super(const AsyncValue.data(SearchResult(profiles: [], posts: [], recommendations: [], lists: [])));

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data(SearchResult(profiles: [], posts: [], recommendations: [], lists: []));
      return;
    }

    state = const AsyncValue.loading();
    try {
      // Search profiles
      final profiles = await _supabase
          .from('profiles')
          .select()
          .textSearch('username', query, config: 'english');

      // Search posts
      final posts = await _supabase
          .from('posts')
          .select('*, profiles(username)')
          .textSearch('content', query, config: 'english');

      // Search recommendations
      final recommendations = await _supabase
          .from('travel_recommendations')
          .select('*, profiles(username)')
          .textSearch('title', query, config: 'english');

      // Search lists
      final lists = await _supabase
          .from('lists')
          .select('*, profiles(username)')
          .textSearch('name', query, config: 'english');

      state = AsyncValue.data(SearchResult(
        profiles: profiles,
        posts: posts,
        recommendations: recommendations,
        lists: lists,
      ));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, AsyncValue<SearchResult>>((ref) {
  return SearchNotifier();
});
