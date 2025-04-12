import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/providers/profile_provider.dart';

class FollowNotifier extends StateNotifier<Map<int, List<int>>> {
  final _supabase = Supabase.instance.client;
  final Ref _ref;

  FollowNotifier(this._ref) : super({}) {
    loadFollows();
  }

  Future<void> loadFollows() async {
    final data = await _supabase.from('follows').select();
    final followsMap = <int, List<int>>{};
    for (var follow in data) {
      final followerId = follow['follower_id'] as int;
      final followedId = follow['followed_id'] as int;
      followsMap[followerId] = [...(followsMap[followerId] ?? []), followedId];
    }
    state = followsMap;

    // Update profile followers count
    for (var profile in _ref.read(profileProvider)) {
      final followerCount = data.where((f) => f['followed_id'] == profile.id).length;
      _ref.read(profileProvider.notifier).updateProfile(profile.copyWithDynamic('followers', followerCount));
    }
  }

  Future<void> follow(int followerId, int followedId) async {
    await _supabase.from('follows').insert({
      'follower_id': followerId,
      'followed_id': followedId,
      'followed_at': DateTime.now().toIso8601String(),
    });
    state = {
      ...state,
      followerId: [...(state[followerId] ?? []), followedId],
    };
    final profiles = _ref.read(profileProvider);
    final followedProfile = profiles.firstWhere((p) => p.id == followedId);
    _ref.read(profileProvider.notifier).updateProfile(followedProfile.copyWithDynamic('followers', (followedProfile.followers ?? 0) + 1));
  }

  Future<void> unfollow(int followerId, int followedId) async {
    await _supabase.from('follows').delete().match({'follower_id': followerId, 'followed_id': followedId});
    state = {
      ...state,
      followerId: (state[followerId] ?? []).where((id) => id != followedId).toList(),
    };
    final profiles = _ref.read(profileProvider);
    final followedProfile = profiles.firstWhere((p) => p.id == followedId);
    _ref.read(profileProvider.notifier).updateProfile(followedProfile.copyWithDynamic('followers', (followedProfile.followers ?? 0) - 1));
  }
}

final followProvider = StateNotifierProvider<FollowNotifier, Map<int, List<int>>>((ref) {
  return FollowNotifier(ref);
});
