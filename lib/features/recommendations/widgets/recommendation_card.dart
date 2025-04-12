import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final Map<String, dynamic> recommendation;

  const RecommendationCard({required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  recommendation['title'],
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  recommendation['category'].toString().toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Location: ${recommendation['location']}'),
            const SizedBox(height: 8),
            Text(recommendation['description']),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Rating: '),
                ...List.generate(
                  recommendation['rating'],
                  (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Recommended by: ${recommendation['profiles']['username']}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
