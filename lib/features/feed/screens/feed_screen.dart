import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/post_provider.dart';
import '../widgets/ad_widget.dart';
import '../widgets/post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postProvider);
    return ListView.builder(
      itemCount: posts.length + (posts.length ~/ 3),
      itemBuilder: (context, index) {
        if (index % 4 == 3) {
          return const AdWidget();
        }
        final postIndex = index - (index ~/ 4);
        return PostCard(post: posts[postIndex]);
      },
    );
  }
}
