import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/profile.dart';
import '../../../core/providers/profile_provider.dart';
import '../../lists/providers/list_provider.dart';
import '../../follows/providers/follow_provider.dart';

class UserTooltip extends ConsumerWidget {
  final int profileId;

  const UserTooltip({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profileProvider);
    final profile = profiles.firstWhere((p) => p.id == profileId, orElse: () => Profile(id: profileId, username: 'Unknown', milesTraveled: 0));
    final myId = 1;
    final lists = ref.watch(listProvider)[myId] ?? [];
    final follows = ref.watch(followProvider);
    final isFollowing = follows[myId]?.contains(profileId) ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: const NetworkImage('https://via.placeholder.com/150'),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(profile.username, style: Theme.of(context).textTheme.titleMedium),
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
                  Text('Miles: ${profile.milesTraveled}'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Followers: ${profile.followers ?? 0}'),
              const SizedBox(width: 16),
              Text('Following: ${follows[profileId]?.length ?? 0}'),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              if (isFollowing) {
                ref.read(followProvider.notifier).unfollow(myId, profileId);
              } else {
                ref.read(followProvider.notifier).follow(myId, profileId);
              }
            },
            child: Text(isFollowing ? 'Unfollow' : 'Follow'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 36)),
          ),
          const SizedBox(height: 8),
          if (lists.isNotEmpty) ...[
            DropdownButton<int>(
              hint: const Text('Add to List'),
              isExpanded: true,
              items: lists.map((list) {
                return DropdownMenuItem<int>(
                  value: list['id'],
                  child: Text(list['name']),
                );
              }).toList(),
              onChanged: (listId) {
                if (listId != null) {
                  ref.read(listProvider.notifier).addToList(listId, profileId);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added ${profile.username} to list!')));
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
