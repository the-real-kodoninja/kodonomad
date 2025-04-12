// lib/features/games/widgets/challenge_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodonomad/features/games/providers/game_provider.dart';

class ChallengeCard extends ConsumerWidget {
  final RealLifeChallenge challenge;

  const ChallengeCard({required this.challenge});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(challenge.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(challenge.description),
            const SizedBox(height: 8),
            Text('Reward: ${challenge.rewardPoints} points'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final isInRange = await ref.read(gameProvider.notifier).checkChallengeProximity(challenge);
                if (isInRange) {
                  await ref.read(gameProvider.notifier).completeChallenge(challenge.id, 1); // Replace with actual user ID
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Challenge completed! Points awarded.')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('You are not within the challenge area.')),
                  );
                }
              },
              child: const Text('Complete Challenge'),
            ),
          ],
        ),
      ),
    );
  }
}
