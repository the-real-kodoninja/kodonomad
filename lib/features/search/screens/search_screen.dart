import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodonomad/features/search/providers/search_provider.dart';
import 'package:kodonomad/features/profile/screens/profile_screen.dart';
import 'package:kodonomad/features/lists/screens/list_detail_screen.dart';
import 'package:kodonomad/features/recommendations/widgets/recommendation_card.dart';
import 'package:kodonomad/features/feed/widgets/post_card.dart';

class SearchScreen extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.read(searchProvider.notifier).search(query);
        final results = ref.watch(searchProvider);

        return results.when(
          data: (data) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profiles
                if (data.profiles.isNotEmpty) ...[
                  const Text('Profiles', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...data.profiles.map((profile) => ListTile(
                        title: Text(profile['username']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProfileScreen()), // Navigate to profile
                          );
                        },
                      )),
                ],
                // Posts
                if (data.posts.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Posts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...data.posts.map((post) => PostCard(post: Post.fromMap(post))),
                ],
                // Recommendations
                if (data.recommendations.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Recommendations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...data.recommendations.map((rec) => RecommendationCard(recommendation: rec)),
                ],
                // Lists
                if (data.lists.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Lists', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...data.lists.map((list) => ListTile(
                        title: Text(list['name']),
                        subtitle: Text('Created by: ${list['profiles']['username']}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ListDetailScreen(list: list)),
                          );
                        },
                      )),
                ],
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('Enter a search term to find profiles, posts, recommendations, and lists.'));
  }
}
