import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kodonomad/core/models/profile.dart'; // Root import

class RecommendationNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final _supabase = Supabase.instance.client;

  RecommendationNotifier() : super([]) {
    loadRecommendations();
  }

  Future<void> loadRecommendations() async {
    final data = await _supabase
        .from('travel_recommendations')
        .select('*, profiles(username)')
        .order('created_at', ascending: false);
    state = data;
  }

  Future<void> addRecommendation({
    required int profileId,
    required String category,
    required String title,
    required String description,
    required String location,
    required int rating,
  }) async {
    final newRecommendation = await _supabase.from('travel_recommendations').insert({
      'profile_id': profileId,
      'category': category,
      'title': title,
      'description': description,
      'location': location,
      'rating': rating,
      'created_at': DateTime.now().toIso8601String(),
    }).select('*, profiles(username)').single();
    state = [newRecommendation, ...state];
  }
}

final recommendationProvider = StateNotifierProvider<RecommendationNotifier, List<Map<String, dynamic>>>((ref) {
  return RecommendationNotifier();
});
