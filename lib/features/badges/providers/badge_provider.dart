import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/models/profile.dart';
import '../../core/providers/profile_provider.dart';

class BadgeNotifier extends StateNotifier<Map<int, List<Map<String, dynamic>>>> {
  final _supabase = Supabase.instance.client;
  final Ref _ref;

  BadgeNotifier(this._ref) : super({}) {
    _initBadgeListeners();
  }

  void _initBadgeListeners() {
    _ref.listen(profileProvider, (previous, next) {
      for (var profile in next) {
        _checkHikingBadges(profile);
        _checkCampingBadges(profile);
        // Add more badge checks
      }
    });
  }

  Future<void> loadBadges(int profileId) async {
    final badges = await _supabase.from('badges').select().eq('profile_id', profileId);
    state = {...state, profileId: badges};
    await _updateLeaderboard(profileId, badges.length);
  }

  Future<void> _updateLeaderboard(int profileId, int badgeCount) async {
    final profile = await _supabase.from('profiles').select('miles_traveled').eq('id', profileId).single();
    await _supabase.from('leaderboard').upsert({
      'profile_id': profileId,
      'total_badges': badgeCount,
      'total_miles': profile['miles_traveled'],
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _awardBadge(int profileId, String name, int level) async {
    await _supabase.from('badges').insert({
      'profile_id': profileId,
      'name': name,
      'level': level,
      'earned_date': DateTime.now().toIso8601String(),
    });
    await loadBadges(profileId);
  }

  Future<void> _checkHikingBadges(Profile profile) async {
    final miles = profile.milesTraveled;
    if (miles >= 100 && !state[profile.id]!.any((b) => b['name'] == 'Trailblazer' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Trailblazer', 1);
    }
    if (miles >= 500 && !state[profile.id]!.any((b) => b['name'] == 'Trailblazer' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Trailblazer', 2);
    }
    if (miles >= 1000 && !state[profile.id]!.any((b) => b['name'] == 'Trailblazer' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Trailblazer', 3);
    }
    if (miles >= 5000 && !state[profile.id]!.any((b) => b['name'] == 'Trailblazer' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Trailblazer', 4);
    }
    if (miles >= 10000 && !state[profile.id]!.any((b) => b['name'] == 'Trailblazer' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'Trailblazer', 5);
    }
    // Add similar checks for Nomad Navigator, Globe Trotter, Pathfinder
  }

  Future<void> _checkCampingBadges(Profile profile) async {
    final campingNights = profile.campingNights ?? 0; // Assume this field exists
    if (campingNights >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Campfire King' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Campfire King', 1);
    }
    if (campingNights >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Campfire King' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Campfire King', 2);
    }
    if (campingNights >= 100 && !state[profile.id]!.any((b) => b['name'] == 'Campfire King' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Campfire King', 3);
    }
    // Add checks for Stealth Camper, No-Knock Nomad, Urban Survivor, Wilderness Sleeper
  }

  // Add methods for other badge categories
}

final badgeProvider = StateNotifierProvider.family<BadgeNotifier, Map<int, List<Map<String, dynamic>>>, int>((ref, profileId) {
  final notifier = BadgeNotifier(ref);
  notifier.loadBadges(profileId);
  return notifier;
});
