import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/post_provider.dart';
import '../providers/comment_provider.dart';
import '../models/post.dart';
import '../screens/comment_screen.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myId = 1;
    final isLiked = ref.watch(postProvider.select((posts) => posts.any((p) => p.id == post.id && ref.read(postProvider.notifier).isLiked(p.id, myId))));
    final comments = ref.watch(commentProvider).value[post.id] ?? [];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider('https://via.placeholder.com/150'),
                ),
                SizedBox(width: 8),
                Text('NomadUser', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            SizedBox(height: 8),
            Text(post.content),
            if (post.imageUrl != null) ...[
              SizedBox(height: 8),
              CachedNetworkImage(imageUrl: post.imageUrl!),
            ],
            SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                  color: isLiked ? Colors.red : null,
                  onPressed: () async {
                    if (await ref.read(postProvider.notifier).isLiked(post.id, myId)) {
                      ref.read(postProvider.notifier).unlikePost(post.id, myId);
                    } else {
                      ref.read(postProvider.notifier).likePost(post.id, myId);
                    }
                  },
                ),
                Text('${post.likes}'),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    ref.read(postProvider.notifier).sharePost(post.id, myId);
                  },
                ),
                Text('${post.shares ?? 0}'),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CommentScreen(postId: post.id)),
                    );
                  },
                ),
                Text('${comments.length}'),
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
