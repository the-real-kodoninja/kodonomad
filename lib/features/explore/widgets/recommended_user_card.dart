import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodonomad/core/models/profile.dart';
import 'package:kodonomad/features/follows/providers/follow_provider.dart';

class RecommendedUserCard extends ConsumerWidget {
  final Profile user;

  const RecommendedUserCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myId = 1;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        title: Text(user.username),
        subtitle: Text('Followers: ${user.followers ?? 0}'),
        trailing: ElevatedButton(
          onPressed: () {
            ref.read(followProvider.notifier).follow(myId, user.id);
          },
          child: const Text('Follow'),
        ),
      ),
    );
  }
}
