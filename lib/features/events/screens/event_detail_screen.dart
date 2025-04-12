import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/event.dart';
import '../../../core/providers/profile_provider.dart';
import '../providers/event_provider.dart';

class EventDetailScreen extends ConsumerWidget {
  final Event event;

  const EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profileProvider);
    final myProfile = profiles.isNotEmpty ? profiles.first : null;
    final participants = ref.watch(eventProvider.notifier).getParticipants(event.id);

    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Created by: ${event.creatorUsername ?? "Unknown"}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Location: ${event.location}'),
            Text('Start Time: ${event.startTime}'),
            const SizedBox(height: 16),
            Text(event.description),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(eventProvider.notifier).joinEvent(event.id, myProfile?.id ?? 1);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Joined Event!')));
              },
              child: const Text('Join Event'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            ),
            const SizedBox(height: 16),
            const Text('Participants:', style: TextStyle(fontWeight: FontWeight.bold)),
            FutureBuilder<List<int>>(
              future: participants,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final participantIds = snapshot.data!;
                return Text(participantIds.length.toString());
              },
            ),
          ],
        ),
      ),
    );
  }
}
