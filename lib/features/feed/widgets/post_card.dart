import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/providers/post_provider.dart';
import '../../../core/providers/comment_provider.dart';
import '../../../core/models/post.dart';
import '../../../core/providers/profile_provider.dart';
import '../../nimbus/screens/nimbus_screen.dart';
import '../../forums/screens/comment_screen.dart';
import '../providers/follow_provider.dart';
import '../../tips/widgets/tip_dialog.dart';
import '../../profile/widgets/user_tooltip.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myId = 1; // Replace with actual user ID
    final isLiked = ref.watch(postProvider.select((posts) => posts.any((p) => p.id == post.id && ref.read(postProvider.notifier).isLiked(p.id, myId))));
    final comments = ref.watch(commentProvider).state[post.id] ?? [];
    final profiles = ref.watch(profileProvider);
    final profile = profiles.firstWhere((p) => p.id == post.profileId, orElse: () => Profile(id: post.profileId, username: 'Unknown', milesTraveled: 0));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Tooltip(
              message: '', // Custom tooltip
              preferBelow: false,
              triggerMode: TooltipTriggerMode.longPress,
              showDuration: const Duration(seconds: 5),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: UserTooltip(profileId: post.profileId),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: const CachedNetworkImageProvider('https://via.placeholder.com/150'),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              profile.username,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (profile.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.verified, color: Colors.blue, size: 16),
                            ],
                            if (profile.flairIcon != null) ...[
                              const SizedBox(width: 4),
                              Text(profile.flairIcon!, style: const TextStyle(fontSize: 16)),
                            ],
                          ],
                        ),
                        Text(
                          post.timestamp.toString().substring(0, 16),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Consumer(
                      builder: (context, ref, child) {
                        final follows = ref.watch(followProvider);
                        final isFollowing = follows[myId]?.contains(post.profileId) ?? false;
                        return ElevatedButton(
                          onPressed: () {
                            if (isFollowing) {
                              ref.read(followProvider.notifier).unfollow(myId, post.profileId);
                            } else {
                              ref.read(followProvider.notifier).follow(myId, post.profileId);
                            }
                          },
                          child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 36),
                            backgroundColor: isFollowing ? Colors.grey : Theme.of(context).colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(post.content, style: Theme.of(context).textTheme.bodyLarge),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(imageUrl: post.imageUrl!, fit: BoxFit.cover),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NimbusScreen())),
                ),
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
                Text('${post.likes}', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {
                    ref.read(postProvider.notifier).sharePost(post.id, myId);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.monetization_on),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => TipDialog(receiverId: post.profileId),
                    );
                  },
                ),
                Text('${post.shares ?? 0}', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CommentScreen(postId: post.id)),
                    );
                  },
                ),
                Text('${comments.length}', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
