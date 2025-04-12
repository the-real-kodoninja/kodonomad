import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodonomad/features/recommendations/providers/recommendation_provider.dart';
import 'package:kodonomad/features/recommendations/screens/add_recommendation_screen.dart';
import 'package:kodonomad/features/recommendations/widgets/recommendation_card.dart';

class RecommendationsScreen extends ConsumerWidget {
  const RecommendationsScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendations = ref.watch(recommendationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Recommendations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddRecommendationScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(recommendationProvider.notifier).loadRecommendations();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recommendations.length,
          itemBuilder: (context, index) {
            final recommendation = recommendations[index];
            return RecommendationCard(recommendation: recommendation);
          },
        ),
      ),
    );
  }
}
