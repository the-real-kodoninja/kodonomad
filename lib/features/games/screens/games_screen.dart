// lib/features/games/screens/games_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodonomad/features/games/providers/game_provider.dart';
import 'package:kodonomad/features/games/widgets/game_card.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesData = ref.watch(gameProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Games')),
      body: gamesData.when(
        data: (data) {
          final games = data['games'] as List<Game>;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: games.length,
            itemBuilder: (context, index) {
              return GameCard(game: games[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
