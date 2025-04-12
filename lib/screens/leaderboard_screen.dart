import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaderboardProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await supabase.instance.client.from('leaderboard').select('*, profiles(*)').order('total_badges', ascending: false);
});

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboard = ref.watch(leaderboardProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: leaderboard.when(
        data: (entries) => ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(entry['profiles']['username'] ?? 'Nomad'),
              subtitle: Text('Badges: ${entry['total_badges']} | Miles: ${entry['total_miles']}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Error: $e'),
      ),
    );
  }
}
