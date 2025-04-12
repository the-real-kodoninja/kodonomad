// lib/features/analytics/screens/analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodonomad/core/providers/profile_provider.dart';
import 'package:kodonomad/core/providers/post_provider.dart';
import 'package:kodonomad/core/providers/listing_provider.dart';
import 'package:kodonomad/core/providers/follow_provider.dart';
import 'package:kodonomad/features/analytics/widgets/stat_card.dart';
import 'package:kodonomad/features/analytics/widgets/line_chart.dart';
import 'package:kodonomad/features/analytics/providers/analytics_provider.dart';
import 'package:kodonomad/features/subscriptions/providers/subscription_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myId = 1;
    final subscription = ref.watch(subscriptionProvider)[myId];
    if (subscription == null || subscription == 'basic') {
      return Scaffold(
        appBar: AppBar(title: const Text('Analytics')),
        body: const Center(
          child: Text('Analytics is available for Pro and Elite subscribers only!'),
        ),
      );
    }

    final profiles = ref.watch(profileProvider);
    final myProfile = profiles.firstWhere((p) => p.id == myId);
    final posts = ref.watch(postProvider);
    final listings = ref.watch(listingProvider);
    final follows = ref.watch(followProvider);
    final analytics = ref.watch(analyticsProvider);

    final myPosts = posts.where((p) => p.profileId == myId).toList();
    final totalLikes = myPosts.fold<int>(0, (sum, post) => sum + (post.likes ?? 0));
    final totalShares = myPosts.fold<int>(0, (sum, post) => sum + (post.shares ?? 0));
    final totalItemsSold = listings.where((l) => l.profileId == myId).length;
    final totalFollowers = myProfile.followers ?? 0;
    final totalFollowing = follows[myId]?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final csv = await ref.read(analyticsProvider.notifier).exportToCsv();
              final directory = await getApplicationDocumentsDirectory();
              final file = File('${directory.path}/analytics_export.csv');
              await file.writeAsString(csv);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Exported to ${file.path}')),
              );
            },
          ),
        ],
      ),
      body: analytics.when(
        data: (data) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Stats
              StatCard(label: 'Total Posts', value: myPosts.length.toString()),
              StatCard(label: 'Total Likes', value: totalLikes.toString()),
              StatCard(label: 'Total Shares', value: totalShares.toString()),
              StatCard(label: 'Items Sold', value: totalItemsSold.toString()),
              StatCard(label: 'Followers', value: totalFollowers.toString()),
              StatCard(label: 'Following', value: totalFollowing.toString()),

              // Engagement Trends
              const SizedBox(height: 16),
              const Text('Engagement Trends (Last 30 Days)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              LineChart(data: data.likesOverTime, color: Colors.blue, label: 'Likes Over Time'),
              LineChart(data: data.sharesOverTime, color: Colors.green, label: 'Shares Over Time'),
              LineChart(data: data.commentsOverTime, color: Colors.orange, label: 'Comments Over Time'),

              // Content Performance
              const SizedBox(height: 16),
              const Text('Content Performance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ...data.contentPerformance.entries.map((entry) {
                final category = entry.key;
                final metrics = entry.value;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category.toUpperCase(), style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('Posts: ${metrics['count']}'),
                        Text('Likes: ${metrics['likes']}'),
                        Text('Shares: ${metrics['shares']}'),
                        Text('Avg Engagement: ${((metrics['likes'] + metrics['shares']) / metrics['count']).toStringAsFixed(1)}/post'),
                      ],
                    ),
                  ),
                );
              }),

              // Elite Features
              if (subscription == 'elite') ...[
                const SizedBox(height: 16),
                const Text('Elite Insights', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Follower Demographics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...data.followerLocations.entries.map((entry) {
                  return StatCard(label: entry.key, value: entry.value.toString());
                }),
                const SizedBox(height: 16),
                StatCard(
                  label: 'Predicted Engagement (Next 30 Days)',
                  value: data.predictedEngagement.toStringAsFixed(1),
                ),
              ],
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
