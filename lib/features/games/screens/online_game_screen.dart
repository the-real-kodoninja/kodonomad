// lib/features/games/screens/online_game_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodonomad/features/games/providers/game_provider.dart';

class OnlineGameScreen extends ConsumerStatefulWidget {
  final Game game;

  const OnlineGameScreen({required this.game});

  @override
  _OnlineGameScreenState createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends ConsumerState<OnlineGameScreen> {
  List<String?> board = List.filled(9, null); // 3x3 Tic-Tac-Toe board
  String currentPlayer = 'X';
  String? winner;
  int myId = 1; // Replace with actual user ID

  @override
  Widget build(BuildContext context) {
    final gameData = ref.watch(gameProvider).value!;
    final sessions = gameData['sessions'] as List<GameSession>;
    final mySessions = sessions.where((s) => s.gameId == widget.game.id).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.game.name)),
      body: Column(
        children: [
          // Display available sessions
          Expanded(
            child: ListView.builder(
              itemCount: mySessions.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(gameProvider.notifier).createSession(widget.game.id, myId);
                      },
                      child: const Text('Create New Session'),
                    ),
                  );
                }
                final session = mySessions[index - 1];
                final participants = session.participants;
                final isJoined = participants.any((p) => p['profile_id'] == myId);
                return ListTile(
                  title: Text('Session #${session.id} - Host: ${participants.firstWhere((p) => p['profile_id'] == session.hostId)['profiles']['username']}'),
                  subtitle: Text('Players: ${participants.length}/2'),
                  trailing: isJoined
                      ? const Text('Joined')
                      : ElevatedButton(
                          onPressed: participants.length < 2
                              ? () {
                                  ref.read(gameProvider.notifier).joinSession(session.id, myId);
                                }
                              : null,
                          child: const Text('Join'),
                        ),
                  onTap: isJoined && participants.length == 2
                      ? () {
                          setState(() {
                            board = List.filled(9, null);
                            currentPlayer = 'X';
                            winner = null;
                          });
                        }
                      : null,
                );
              },
            ),
          ),

          // Tic-Tac-Toe game board
          if (mySessions.any((s) => s.participants.any((p) => p['profile_id'] == myId) && s.participants.length == 2)) ...[
            const SizedBox(height: 16),
            Text(winner != null ? 'Winner: $winner' : 'Current Player: $currentPlayer'),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (board[index] == null && winner == null) {
                      setState(() {
                        board[index] = currentPlayer;
                        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
                        winner = _checkWinner();
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    color: Colors.grey[200],
                    child: Center(
                      child: Text(
                        board[index] ?? '',
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  String? _checkWinner() {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] != null &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]]) {
        return board[pattern[0]];
      }
    }

    if (board.every((cell) => cell != null)) {
      return 'Draw';
    }

    return null;
  }
}
