// lib/features/explore/providers/explore_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kodonomad/core/models/post.dart';
import 'package:kodonomad/core/models/profile.dart';
import 'package:kodonomad/core/providers/post_provider.dart';
import 'package:kodonomad/core/providers/profile_provider.dart';
import 'package:kodonomad/core/providers/follow_provider.dart';
import 'package:kodonomad/features/events/providers/event_provider.dart';
import 'package:kodonomad/features/challenges/providers/challenge_provider.dart';
import 'package:kodonomad/utils/location_service.dart';

class ExploreData {
  final List<Post> trendingPosts;
  final List<Profile> recommendedUsers;
  final List<Map<String, dynamic>> nearbySpots;
  final List<Map<String, dynamic>> curatedEvents;
  final List<Map<String, dynamic>> curatedChallenges;

  ExploreData({
    required this.trendingPosts,
    required this.recommendedUsers,
    required this.nearbySpots,
    required this.curatedEvents,
    required this.curatedChallenges,
  });
}

class ExploreNotifier extends StateNotifier<AsyncValue<ExploreData>> {
  final Ref _ref;
  final _supabase = Supabase.instance.client;

  ExploreNotifier(this._ref) : super(const AsyncValue.loading()) {
    fetchExploreData();
  }

  Future<void> fetchExploreData() async {
    try {
      state = const AsyncValue.loading();
      final myId = 1;
      final follows = _ref.read(followProvider);

      // Fetch trending posts from Supabase, ordered by trending_score
      final trendingPostsData = await _supabase
          .from('posts')
          .select('*, profiles(username)')
          .order('trending_score', ascending: false)
          .limit(10);
      final trendingPosts = trendingPostsData.map((map) => Post.fromMap(map)).toList();

      // Fetch recommended users based on mutual followers and activity
      final profiles = _ref.read(profileProvider);
      final recommendedUsers = profiles
          .where((p) => p.id != myId && !(follows[myId]?.contains(p.id) ?? false))
          .toList()
        ..sort((a, b) => (b.followers ?? 0).compareTo(a.followers ?? 0))
        ..take(5);

      // Fetch nearby spots using the user's location
      final position = await LocationService.getCurrentLocation();
      final nearbySpots = await LocationService.fetchNearbySpots(
        position.latitude,
        position.longitude,
      );

      // Fetch curated events and challenges
      final events = _ref.read(eventProvider);
      final challenges = _ref.read(challengeProvider);
      final curatedEvents = events.take(3).toList();
      final curatedChallenges = challenges.take(3).toList();

      state = AsyncValue.data(ExploreData(
        trendingPosts: trendingPosts,
        recommendedUsers: recommendedUsers,
        nearbySpots: nearbySpots,
        curatedEvents: curatedEvents,
        curatedChallenges: curatedChallenges,
      ));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final exploreProvider = StateNotifierProvider<ExploreNotifier, AsyncValue<ExploreData>>((ref) {
  return ExploreNotifier(ref);
});
