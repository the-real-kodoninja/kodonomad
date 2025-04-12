import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/list_card.dart';
import '../screens/list_detail_screen.dart';
import '../../../core/providers/profile_provider.dart';
import '../providers/list_provider.dart';

class ListsScreen extends ConsumerWidget {
  const ListsScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profileProvider);
    final myId = 1;
    final myProfile = profiles.firstWhere((p) => p.id == myId);
    final lists = ref.watch(listProvider)[myId] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Create List'),
                  content: TextField(
                    decoration: const InputDecoration(labelText: 'List Name'),
                    onSubmitted: (value) {
                      ref.read(listProvider.notifier).createList(myId, value);
                      Navigator.pop(context);
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: lists.length,
        itemBuilder: (context, index) {
          final list = lists[index];
          return ListCard(
            list: list,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ListDetailScreen(list: list)),
            ),
          );
        },
      ),
    );
  }
}
