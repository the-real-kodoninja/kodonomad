import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/post_provider.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  void addNewPost(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Post'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'What’s on your mind?'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(postProvider.notifier).addPost(
                  Post(
                    id: 0,
                    profileId: 1,
                    content: controller.text,
                    timestamp: DateTime.now(),
                    likes: 0,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final posts = ref.watch(postProvider);
        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(postProvider.notifier).loadPosts();
          },
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(post: post).animate().fadeIn(duration: 300.ms);
            },
          ),
        );
      },
    );
  }
}
