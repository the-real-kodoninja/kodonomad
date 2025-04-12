import 'package:flutter/material.dart';
import 'package:kodonomad/core/models/post.dart';

class TrendingPostCard extends StatelessWidget {
  final Post post;

  const TrendingPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trending Post', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.redAccent)),
            const SizedBox(height: 8),
            Text(post.content),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.favorite, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${post.likes ?? 0}'),
                const SizedBox(width: 16),
                const Icon(Icons.share, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${post.shares ?? 0}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
