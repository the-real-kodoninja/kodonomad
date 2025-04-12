import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodonomad/features/explore/providers/explore_provider.dart';
import 'package:kodonomad/features/explore/widgets/trending_post_card.dart';
import 'package:kodonomad/features/explore/widgets/recommended_user_card.dart';
import 'package:kodonomad/features/explore/widgets/nearby_spot_card.dart';
import 'package:kodonomad/features/events/screens/event_detail_screen.dart';
import 'package:kodonomad/features/challenges/screens/challenge_detail_screen.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exploreData = ref.watch(exploreProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: exploreData.when(
        data: (data) => RefreshIndicator(
          onRefresh: () async {
            await ref.read(exploreProvider.notifier).fetchExploreData();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trending Posts
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Trending Posts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ...data.trendingPosts.map((post) => TrendingPostCard(post: post)),

                // Recommended Users
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Recommended Users', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ...data.recommendedUsers.map((user) => RecommendedUserCard(user: user)),

                // Nearby Spots
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Nearby Nomad Spots', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ...data.nearbySpots.map((spot) => NearbySpotCard(spot: spot)),

                // Curated Events
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Curated Events', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ...data.curatedEvents.map((event) => ListTile(
                      title: Text(event['name']),
                      subtitle: Text(event['date']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
                        );
                      },
                    )),

                // Curated Challenges
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Curated Challenges', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ...data.curatedChallenges.map((challenge) => ListTile(
                      title: Text(challenge['name']),
                      subtitle: Text(challenge['description']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ChallengeDetailScreen(challenge: challenge)),
                        );
                      },
                    )),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
