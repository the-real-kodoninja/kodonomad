// lib/features/games/widgets/game_card.dart
import 'package:flutter/material.dart';
import 'package:kodonomad/features/games/providers/game_provider.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(game.name),
        subtitle: Text(game.description),
        trailing: Text(game.type == 'online' ? 'Online' : 'Real-Life'),
        onTap: () {
          if (game.type == 'online') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OnlineGameScreen(game: game),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RealLifeGameScreen(game: game),
              ),
            );
          }
        },
      ),
    );
  }
}
