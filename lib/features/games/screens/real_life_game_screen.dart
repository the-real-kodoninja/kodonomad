// lib/features/games/screens/real_life_game_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodonomad/features/games/providers/game_provider.dart';
import 'package:kodonomad/features/games/widgets/challenge_card.dart';
import 'package:kodonomad/features/games/providers/nomad_quest_provider.dart';
import 'package:kodonomad/features/games/screens/nomad_stop_ar_screen.dart';

class RealLifeGameScreen extends ConsumerWidget {
  final Game game;

  const RealLifeGameScreen({required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameData = ref.watch(gameProvider).value!;
    final challenges = (gameData['challenges'] as List<RealLifeChallenge>)
        .where((c) => c.gameId == game.id)
        .toList();
    final nomadQuestData = ref.watch(nomadQuestProvider).value;
    final nomadStops = nomadQuestData != null ? nomadQuestData['stops'] as List<NomadStop> : [];

    return Scaffold(
      appBar: AppBar(title: Text(game.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nomad Quest Section
            const Text('Nomad Quest: Discover Hidden Treasures', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Travel to nomad stops, complete challenges, and collect artifacts with the help of Nimbus.ai!'),
            const SizedBox(height: 16),
            ...nomadStops.map((stop) => ListTile(
                  title: Text(stop.name),
                  subtitle: Text(stop.description),
                  onTap: () async {
                    final isInRange = await ref.read(nomadQuestProvider.notifier).checkProximity(stop);
                    if (isInRange) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NomadStopARScreen(stop: stop),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('You are not within the nomad stop area.')),
                      );
                    }
                  },
                )),

            // Existing Challenges
            const SizedBox(height: 16),
            const Text('Other Challenges', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...challenges.map((challenge) => ChallengeCard(challenge: challenge)),
          ],
        ),
      ),
    );
  }
}
