import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/challenge.dart';
import '../providers/challenge_provider.dart';

class ChallengeCard extends ConsumerStatefulWidget {
  final Challenge challenge;
  final VoidCallback onJoin;
  final Function(int) onUpdateProgress;

  const ChallengeCard({required this.challenge, required this.onJoin, required this.onUpdateProgress});

  @override
  _ChallengeCardState createState() => _ChallengeCardState();
}

class _ChallengeCardState extends ConsumerState<ChallengeCard> {
  int _progress = 0;

  @override
  Widget build(BuildContext context) {
    final myId = 1; // Replace with actual user ID
    final status = ref.watch(challengeProvider.notifier).getParticipantStatus(widget.challenge.id, myId);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.challenge.title, style: Theme.of(context).textTheme.titleMedium),
            Text(widget.challenge.description),
            Text('Goal: ${widget.challenge.goal}'),
            Text('Duration: ${widget.challenge.startDate} - ${widget.challenge.endDate}'),
            const SizedBox(height: 8),
            FutureBuilder<Map<String, dynamic>>(
              future: status,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final data = snapshot.data!;
                final joined = data['progress'] != null;
                _progress = data['progress'] ?? 0;
                return Column(
                  children: [
                    if (!joined)
                      ElevatedButton(
                        onPressed: widget.onJoin,
                        child: const Text('Join Challenge'),
                      ),
                    if (joined) ...[
                      Text('Progress: $_progress/${widget.challenge.goal}'),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Update Progress'),
                        keyboardType: TextInputType.number,
                        onSubmitted: (value) {
                          final newProgress = int.parse(value);
                          setState(() => _progress = newProgress);
                          widget.onUpdateProgress(newProgress);
                        },
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
