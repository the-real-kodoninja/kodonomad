// lib/features/games/providers/game_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kodonomad/utils/location_service.dart';

class Game {
  final int id;
  final String name;
  final String type;
  final String description;

  Game({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
  });

  factory Game.fromMap(Map<String, dynamic> map) => Game(
        id: map['id'],
        name: map['name'],
        type: map['type'],
        description: map['description'],
      );
}

class GameSession {
  final int id;
  final int gameId;
  final int hostId;
  final String status;
  final List<Map<String, dynamic>> participants;

  GameSession({
    required this.id,
    required this.gameId,
    required this.hostId,
    required this.status,
    required this.participants,
  });

  factory GameSession.fromMap(Map<String, dynamic> map, List<Map<String, dynamic>> participants) => GameSession(
        id: map['id'],
        gameId: map['game_id'],
        hostId: map['host_id'],
        status: map['status'],
        participants: participants,
      );
}

class RealLifeChallenge {
  final int id;
  final int gameId;
  final String name;
  final String description;
  final double lat;
  final double lng;
  final int radius;
  final int rewardPoints;

  RealLifeChallenge({
    required this.id,
    required this.gameId,
    required this.name,
    required this.description,
    required this.lat,
    required this.lng,
    required this.radius,
    required this.rewardPoints,
  });

  factory RealLifeChallenge.fromMap(Map<String, dynamic> map) => RealLifeChallenge(
        id: map['id'],
        gameId: map['game_id'],
        name: map['name'],
        description: map['description'],
        lat: map['location_lat'],
        lng: map['location_lng'],
        radius: map['radius'],
        rewardPoints: map['reward_points'],
      );
}

class GameNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final Ref _ref;
  final _supabase = Supabase.instance.client;
  late final RealtimeChannel _channel;

  GameNotifier(this._ref) : super(const AsyncValue.loading()) {
    fetchGames();
    _setupRealtime();
  }

  Future<void> fetchGames() async {
    try {
      state = const AsyncValue.loading();

      // Fetch all games
      final gamesData = await _supabase.from('games').select();
      final games = gamesData.map((map) => Game.fromMap(map)).toList();

      void _setupRealtime() {
    _channel = _supabase.channel('games');
    _channel.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: '*', schema: 'public', table: 'game_sessions'),
      (payload, [ref]) {
        fetchGames();
      },
    ).subscribe();
  }

  @override
  void dispose() {
    _supabase.removeChannel(_channel);
    super.dispose();
  }

      // Fetch active sessions
      final sessionsData = await _supabase
          .from('game_sessions')
          .select('*, game_participants(*, profiles(username))')
          .eq('status', 'waiting');
      final sessions = sessionsData.map((map) {
        final participants = (map['game_participants'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
        return GameSession.fromMap(map, participants);
      }).toList();

      // Fetch real-life challenges
      final challengesData = await _supabase.from('real_life_challenges').select();
      final challenges = challengesData.map((map) => RealLifeChallenge.fromMap(map)).toList();

      state = AsyncValue.data({
        'games': games,
        'sessions': sessions,
        'challenges': challenges,
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Create a new game session
  Future<void> createSession(int gameId, int hostId) async {
    final session = await _supabase.from('game_sessions').insert({
      'game_id': gameId,
      'host_id': hostId,
      'status': 'waiting',
    }).select().single();

    await _supabase.from('game_participants').insert({
      'session_id': session['id'],
      'profile_id': hostId,
    });

    await fetchGames();
  }

  // Join an existing game session
  Future<void> joinSession(int sessionId, int profileId) async {
    await _supabase.from('game_participants').insert({
      'session_id': sessionId,
      'profile_id': profileId,
    });
    await fetchGames();
  }

  // Check if a user is within a challenge's geofence
  Future<bool> checkChallengeProximity(RealLifeChallenge challenge) async {
    final position = await LocationService.getCurrentLocation();
    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      challenge.lat,
      challenge.lng,
    );
    return distance <= challenge.radius;
  }

  // Complete a real-life challenge
  Future<void> completeChallenge(int challengeId, int profileId) async {
    // Add reward points to the user's profile (requires a points column in profiles)
    final challenge = state.value!['challenges'].firstWhere((c) => c.id == challengeId);
    await _supabase.from('profiles').update({
      'points': _supabase.raw('points + ${challenge.rewardPoints}'),
    }).eq('id', profileId);
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  return GameNotifier(ref);
});
