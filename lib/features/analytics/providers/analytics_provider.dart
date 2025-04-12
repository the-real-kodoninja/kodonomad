// lib/features/analytics/providers/analytics_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kodonomad/core/models/post.dart';
import 'package:kodonomad/core/models/profile.dart';
import 'package:kodonomad/core/providers/post_provider.dart';
import 'package:kodonomad/core/providers/profile_provider.dart';
import 'package:kodonomad/core/providers/follow_provider.dart';

class AnalyticsData {
  final Map<DateTime, int> likesOverTime;
  final Map<DateTime, int> sharesOverTime;
  final Map<DateTime, int> commentsOverTime;
  final Map<String, int> followerLocations;
  final Map<String, Map<String, dynamic>> contentPerformance;
  final double predictedEngagement;

  AnalyticsData({
    required this.likesOverTime,
    required this.sharesOverTime,
    required this.commentsOverTime,
    required this.followerLocations,
    required this.contentPerformance,
    required this.predictedEngagement,
  });
}

class AnalyticsNotifier extends StateNotifier<AsyncValue<AnalyticsData>> {
  final Ref _ref;
  final _supabase = Supabase.instance.client;

  AnalyticsNotifier(this._ref) : super(const AsyncValue.loading()) {
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    try {
      state = const AsyncValue.loading();
      final myId = 1; // Replace with actual user ID
      final posts = _ref.read(postProvider).where((p) => p.profileId == myId).toList();
      final profiles = _ref.read(profileProvider);
      final follows = _ref.read(followProvider);

      // Fetch interactions
      final interactions = await _supabase
          .from('post_interactions')
          .select()
          .eq('profile_id', myId)
          .gte('timestamp', DateTime.now().subtract(const Duration(days: 30)).toIso8601String());

      // Likes, Shares, Comments Over Time
      final likesOverTime = <DateTime, int>{};
      final sharesOverTime = <DateTime, int>{};
      final commentsOverTime = <DateTime, int>{};
      for (var i = 0; i < 30; i++) {
        final date = DateTime.now().subtract(Duration(days: i));
        likesOverTime[DateTime(date.year, date.month, date.day)] = 0;
        sharesOverTime[DateTime(date.year, date.month, date.day)] = 0;
        commentsOverTime[DateTime(date.year, date.month, date.day)] = 0;
      }

      for (var interaction in interactions) {
        final timestamp = DateTime.parse(interaction['timestamp']);
        final date = DateTime(timestamp.year, timestamp.month, timestamp.day);
        if (interaction['interaction_type'] == 'like') {
          likesOverTime[date] = (likesOverTime[date] ?? 0) + 1;
        } else if (interaction['interaction_type'] == 'share') {
          sharesOverTime[date] = (sharesOverTime[date] ?? 0) + 1;
        } else if (interaction['interaction_type'] == 'comment') {
          commentsOverTime[date] = (commentsOverTime[date] ?? 0) + 1;
        }
      }

      // Follower Locations (requires location data in profiles)
      final followerIds = follows[myId] ?? [];
      final followerLocations = <String, int>{};
      for (var followerId in followerIds) {
        final follower = profiles.firstWhere((p) => p.id == followerId);
        final location = follower.location ?? 'Unknown';
        followerLocations[location] = (followerLocations[location] ?? 0) + 1;
      }

      // Content Performance by Category
      final contentPerformance = <String, Map<String, dynamic>>{};
      for (var post in posts) {
        final category = post.category ?? 'uncategorized';
        if (!contentPerformance.containsKey(category)) {
          contentPerformance[category] = {'likes': 0, 'shares': 0, 'count': 0};
        }
        contentPerformance[category]!['likes'] = (contentPerformance[category]!['likes'] as int) + (post.likes ?? 0);
        contentPerformance[category]!['shares'] = (contentPerformance[category]!['shares'] as int) + (post.shares ?? 0);
        contentPerformance[category]!['count'] = (contentPerformance[category]!['count'] as int) + 1;
      }

      // Predictive Engagement (simple linear regression based on past 30 days)
      double totalEngagement = 0;
      int daysWithEngagement = 0;
      for (var i = 0; i < 30; i++) {
        final date = DateTime.now().subtract(Duration(days: i));
        final dateKey = DateTime(date.year, date.month, date.day);
        final engagement = (likesOverTime[dateKey] ?? 0) + (sharesOverTime[dateKey] ?? 0) + (commentsOverTime[dateKey] ?? 0);
        if (engagement > 0) {
          totalEngagement += engagement;
          daysWithEngagement++;
        }
      }
      final avgDailyEngagement = daysWithEngagement > 0 ? totalEngagement / daysWithEngagement : 0;
      final predictedEngagement = avgDailyEngagement * 1.1; // 10% growth assumption

      state = AsyncValue.data(AnalyticsData(
        likesOverTime: likesOverTime,
        sharesOverTime: sharesOverTime,
        commentsOverTime: commentsOverTime,
        followerLocations: followerLocations,
        contentPerformance: contentPerformance,
        predictedEngagement: predictedEngagement,
      ));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<String> exportToCsv() async {
    final data = state.value!;
    final buffer = StringBuffer();
    buffer.writeln('Metric,Value');
    buffer.writeln('Likes Over Time');
    data.likesOverTime.forEach((date, count) {
      buffer.writeln('${date.toIso8601String()},$count');
    });
    buffer.writeln('Shares Over Time');
    data.sharesOverTime.forEach((date, count) {
      buffer.writeln('${date.toIso8601String()},$count');
    });
    buffer.writeln('Comments Over Time');
    data.commentsOverTime.forEach((date, count) {
      buffer.writeln('${date.toIso8601String()},$count');
    });
    buffer.writeln('Follower Locations');
    data.followerLocations.forEach((location, count) {
      buffer.writeln('$location,$count');
    });
    buffer.writeln('Content Performance');
    data.contentPerformance.forEach((category, metrics) {
      buffer.writeln('$category,Likes,${metrics['likes']},Shares,${metrics['shares']},Posts,${metrics['count']}');
    });
    buffer.writeln('Predicted Engagement,${data.predictedEngagement}');
    return buffer.toString();
  }
}

final analyticsProvider = StateNotifierProvider<AnalyticsNotifier, AsyncValue<AnalyticsData>>((ref) {
  return AnalyticsNotifier(ref);
});
