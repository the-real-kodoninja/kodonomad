import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/challenge.dart';
import '../../../core/providers/profile_provider.dart';

class ChallengeNotifier extends StateNotifier<List<Challenge>> {
  final _supabase = Supabase.instance.client;
  final Ref _ref;

  ChallengeNotifier(this._ref) : super([]) {
    loadChallenges();
  }

  Future<void> loadChallenges() async {
    final data = await _supabase.from('challenges').select();
    state = data.map((map) => Challenge.fromMap(map)).toList();
  }

  Future<void> joinChallenge(int challengeId, int profileId) async {
    await _supabase.from('challenge_participants').insert({
      'challenge_id': challengeId,
      'profile_id': profileId,
      'progress': 0,
      'completed': false,
    });
  }

  Future<void> updateProgress(int challengeId, int profileId, int progress) async {
    await _supabase.from('challenge_participants').update({
      'progress': progress,
      'completed': progress >= (state.firstWhere((c) => c.id == challengeId).goal),
    }).match({'challenge_id': challengeId, 'profile_id': profileId});

    final challenge = state.firstWhere((c) => c.id == challengeId);
    if (progress >= challenge.goal) {
      // Reward user
      if (challenge.reward == 'badge') {
        await _supabase.from('badges').insert({
          'profile_id': profileId,
          'name': 'Challenge Champion',
          'level': 1,
          'earned_date': DateTime.now().toIso8601String(),
        });
      }
    }
  }

  Future<Map<String, dynamic>> getParticipantStatus(int challengeId, int profileId) async {
    final data = await _supabase.from('challenge_participants').select().match({'challenge_id': challengeId, 'profile_id': profileId}).single();
    return data;
  }
}
