import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/profile_provider.dart';
import '../providers/badge_provider.dart';

class BadgeGrid extends ConsumerWidget {
  const BadgeGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profileProvider);
    final myId = profiles.isNotEmpty ? profiles.first.id : 1;
    final badges = ref.watch(badgeProvider(myId));
    return SizedBox(
      height: 100,
      child: badges.when(
        data: (badgeMap) {
          final badgeList = badgeMap[myId] ?? [];
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: badgeList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Chip(
                  label: Text('${badgeList[index]['name']} (Level ${badgeList[index]['level']})'),
                  avatar: Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Error: $e'),
      ),
    );
  }
}
