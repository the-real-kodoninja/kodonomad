// lib/features/games/screens/real_life_game_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodonomad/features/games/providers/game_provider.dart';
import 'package:kodonomad/features/games/widgets/challenge_card.dart';

class RealLifeGameScreen extends ConsumerWidget {
  final Game game;

  const RealLifeGameScreen({required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameData = ref.watch(gameProvider).value!;
    final challenges = (gameData['challenges'] as List<RealLifeChallenge>)
        .where((c) => c.gameId == game.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(game.name)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          return ChallengeCard(challenge: challenges[index]);
        },
      ),
    );
  }
}
