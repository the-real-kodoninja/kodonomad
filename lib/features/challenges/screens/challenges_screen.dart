import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/challenge_card.dart';
import '../../../core/providers/profile_provider.dart';
import '../providers/challenge_provider.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(challengeProvider);
    final profiles = ref.watch(profileProvider);
    final myProfile = profiles.isNotEmpty ? profiles.first : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Challenges')),
      body: ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return ChallengeCard(
            challenge: challenge,
            onJoin: () => ref.read(challengeProvider.notifier).joinChallenge(challenge.id, myProfile?.id ?? 1),
            onUpdateProgress: (progress) => ref.read(challengeProvider.notifier).updateProgress(challenge.id, myProfile?.id ?? 1, progress),
          );
        },
      ),
    );
  }
}
