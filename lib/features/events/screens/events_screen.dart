import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/event_card.dart';
import '../../../core/providers/profile_provider.dart';
import '../providers/event_provider.dart';
import 'event_detail_screen.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventProvider);
    final profiles = ref.watch(profileProvider);
    final myProfile = profiles.isNotEmpty ? profiles.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateEventScreen(profileId: myProfile?.id ?? 1),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return EventCard(
            event: event,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
            ),
          );
        },
      ),
    );
  }
}

class CreateEventScreen extends ConsumerStatefulWidget {
  final int profileId;

  const CreateEventScreen({required this.profileId});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _startTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextButton(
              onPressed: () async {
                final picked = await showDateTimePicker(context: context);
                if (picked != null) {
                  setState(() => _startTime = picked);
                }
              },
              child: Text(_startTime == null ? 'Pick Start Time' : _startTime.toString()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_startTime == null) return;
                final event = Event(
                  id: 0, // Will be set by Supabase
                  profileId: widget.profileId,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  location: _locationController.text,
                  startTime: _startTime!,
                  createdAt: DateTime.now(),
                );
                ref.read(eventProvider.notifier).createEvent(event);
                Navigator.pop(context);
              },
              child: const Text('Create Event'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            ),
          ],
        ),
      ),
    );
  }
}
