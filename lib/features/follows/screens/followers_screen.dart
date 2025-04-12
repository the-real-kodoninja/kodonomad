import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/profile_provider.dart';
import '../providers/follow_provider.dart';

class FollowersScreen extends ConsumerWidget {
  final int profileId;

  const FollowersScreen({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final follows = ref.watch(followProvider);
    final profiles = ref.watch(profileProvider);
    final followers = follows.entries.where((entry) => entry.value.contains(profileId)).map((e) => e.key).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Followers')),
      body: ListView.builder(
        itemCount: followers.length,
        itemBuilder: (context, index) {
          final followerId = followers[index];
          final follower = profiles.firstWhere((p) => p.id == followerId, orElse: () => Profile(id: followerId, username: 'Unknown', milesTraveled: 0));
          return ListTile(
            title: Text(follower.username),
            trailing: IconButton(
              icon: const Icon(Icons.person_remove),
              onPressed: () => ref.read(followProvider.notifier).unfollow(followerId, profileId),
            ),
          );
        },
      ),
    );
  }
}
