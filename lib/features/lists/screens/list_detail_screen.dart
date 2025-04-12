import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/profile_provider.dart';
import '../providers/list_provider.dart';

class ListDetailScreen extends ConsumerWidget {
  final Map<String, dynamic> list;

  const ListDetailScreen({required this.list});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(listProvider.notifier).getListMembers(list['id']);
    final profiles = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(list['name'])),
      body: FutureBuilder<List<int>>(
        future: members,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final memberIds = snapshot.data!;
          return ListView.builder(
            itemCount: memberIds.length,
            itemBuilder: (context, index) {
              final memberId = memberIds[index];
              final member = profiles.firstWhere((p) => p.id == memberId, orElse: () => Profile(id: memberId, username: 'Unknown', milesTraveled: 0));
              return ListTile(
                title: Text(member.username),
              );
            },
          );
        },
      ),
    );
  }
}
