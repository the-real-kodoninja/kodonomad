import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/forum_provider.dart';
import '../models/forum_post.dart';

class ForumsScreen extends ConsumerStatefulWidget {
  @override
  _ForumsScreenState createState() => _ForumsScreenState();
}

class _ForumsScreenState extends ConsumerState<ForumsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(forumProvider.notifier).loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(forumProvider);
    return Scaffold(
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return ForumPostCard(post: post);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final controller = TextEditingController();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('New Forum Post'),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: 'What’s the topic?'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      ref.read(forumProvider.notifier).addPost(
                            ForumPost(
                              id: 0,
                              profileId: 1,
                              title: controller.text,
                              content: '',
                              timestamp: DateTime.now(),
                              upvotes: 0,
                              downvotes: 0,
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
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ForumPostCard extends ConsumerWidget {
  final ForumPost post;

  const ForumPostCard({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text(post.content),
            SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: () => ref.read(forumProvider.notifier).upvotePost(post.id, 1),
                ),
                Text('${post.upvotes}'),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () => ref.read(forumProvider.notifier).downvotePost(post.id, 1),
                ),
                Text('${post.downvotes}'),
                Spacer(),
                Text(post.timestamp.toString().substring(0, 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
