import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/profile_provider.dart';
import '../providers/follow_provider.dart';

class FollowingScreen extends ConsumerWidget {
  final int profileId;

  const FollowingScreen({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final follows = ref.watch(followProvider);
    final profiles = ref.watch(profileProvider);
    final following = follows[profileId] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Following')),
      body: ListView.builder(
        itemCount: following.length,
        itemBuilder: (context, index) {
          final followedId = following[index];
          final followed = profiles.firstWhere((p) => p.id == followedId, orElse: () => Profile(id: followedId, username: 'Unknown', milesTraveled: 0));
          return ListTile(
            title: Text(followed.username),
            trailing: IconButton(
              icon: const Icon(Icons.person_remove),
              onPressed: () => ref.read(followProvider.notifier).unfollow(profileId, followedId),
            ),
          );
        },
      ),
    );
  }
}
