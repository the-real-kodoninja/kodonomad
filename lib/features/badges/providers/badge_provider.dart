import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/profile.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/providers/post_provider.dart';
import '../../../core/providers/listing_provider.dart';
import '../../../core/providers/notification_provider.dart';
import '../../subscriptions/providers/subscription_provider.dart';
import '../../events/providers/event_provider.dart';
import '../../challenges/providers/challenge_provider.dart';

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
        _checkOutdoorActivityBadges(profile);
        _checkCommunityBadges(profile);
        _checkMarketplaceBadges(profile);
        _checkPremiumBadges(profile);
      }
    });

    _ref.listen(postProvider, (previous, next) {
      final profiles = _ref.read(profileProvider);
      for (var profile in profiles) {
        final userPosts = next.where((post) => post.profileId == profile.id).length;
        _updateProfileField(profile.id, 'stories_posted', userPosts);
      }
    });

    _ref.listen(listingProvider, (previous, next) {
      final profiles = _ref.read(profileProvider);
      for (var profile in profiles) {
        final userItemsSold = next.where((listing) => listing.profileId == profile.id).length;
        final userStickersSold = next.where((listing) => listing.profileId == profile.id && listing.category == 'Sticker').length;
        _updateProfileField(profile.id, 'items_sold', userItemsSold);
        _updateProfileField(profile.id, 'stickers_sold', userStickersSold);
      }
    });

    _ref.listen(eventProvider, (previous, next) {
      final profiles = _ref.read(profileProvider);
      for (var profile in profiles) {
        _checkPremiumBadges(profile);
      }
    });

    _ref.listen(challengeProvider, (previous, next) {
      final profiles = _ref.read(profileProvider);
      for (var profile in profiles) {
        _checkPremiumBadges(profile);
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

  Future<void> _updateProfileField(int profileId, String field, int value) async {
    await _supabase.from('profiles').update({field: value}).eq('id', profileId);
    final profiles = _ref.read(profileProvider);
    final updatedProfile = profiles.firstWhere((p) => p.id == profileId).copyWithDynamic(field, value);
    _ref.read(profileProvider.notifier).updateProfile(updatedProfile);
  }

  Future<void> _awardBadge(int profileId, String name, int level) async {
    await _supabase.from('badges').insert({
      'profile_id': profileId,
      'name': name,
      'level': level,
      'earned_date': DateTime.now().toIso8601String(),
      'is_premium': name.contains('Elite') || name.contains('Pro') || name.contains('Basic'),
    });
    await loadBadges(profileId);

    await _supabase.from('notifications').insert({
      'profile_id': profileId,
      'type': 'badge',
      'content': 'You earned the $name (Level $level) badge!',
      'timestamp': DateTime.now().toIso8601String(),
      'is_read': false,
    });
    _ref.read(notificationProvider.notifier).loadNotifications();
  }

  // Premium Badges
  Future<void> _checkPremiumBadges(Profile profile) async {
    final subscription = _ref.read(subscriptionProvider)[profile.id];
    if (subscription == null) return;

    final events = _ref.read(eventProvider);
    final challenges = _ref.read(challengeProvider);
    final eventParticipants = await _supabase.from('event_participants').select().eq('profile_id', profile.id);
    final challengeParticipants = await _supabase.from('challenge_participants').select().eq('profile_id', profile.id);

    // Basic Tier: Event Enthusiast (Join 5 events)
    if (subscription == 'basic' || subscription == 'pro' || subscription == 'elite') {
      final eventsJoined = eventParticipants.length;
      if (eventsJoined >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Basic Event Enthusiast' && b['level'] == 1)) {
        await _awardBadge(profile.id, 'Basic Event Enthusiast', 1);
      }
      if (eventsJoined >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Basic Event Enthusiast' && b['level'] == 2)) {
        await _awardBadge(profile.id, 'Basic Event Enthusiast', 2);
      }
    }

    // Pro Tier: Challenge Champion (Complete 3 challenges)
    if (subscription == 'pro' || subscription == 'elite') {
      final challengesCompleted = challengeParticipants.where((cp) => cp['completed'] == true).length;
      if (challengesCompleted >= 3 && !state[profile.id]!.any((b) => b['name'] == 'Pro Challenge Champion' && b['level'] == 1)) {
        await _awardBadge(profile.id, 'Pro Challenge Champion', 1);
      }
      if (challengesCompleted >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Pro Challenge Champion' && b['level'] == 2)) {
        await _awardBadge(profile.id, 'Pro Challenge Champion', 2);
      }
    }

    // Elite Tier: Global Influencer (Gain 500 followers and host 5 events)
    if (subscription == 'elite') {
      final followers = profile.followers ?? 0;
      final hostedEvents = events.where((e) => e.profileId == profile.id).length;
      if (followers >= 500 && hostedEvents >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Elite Global Influencer' && b['level'] == 1)) {
        await _awardBadge(profile.id, 'Elite Global Influencer', 1);
      }
      if (followers >= 1000 && hostedEvents >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Elite Global Influencer' && b['level'] == 2)) {
        await _awardBadge(profile.id, 'Elite Global Influencer', 2);
      }
    }
  }

  // Existing badge methods (Hiking, Camping, etc.) remain unchanged
  Future<void> _checkHikingBadges(Profile profile) async {
    final miles = profile.milesTraveled;
    final locations = profile.locationsVisited ?? 0;
    final borders = profile.bordersCrossed ?? 0;
    final trails = profile.trailsDiscovered ?? 0;

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

    if (locations >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Nomad Navigator' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Nomad Navigator', 1);
    }
    if (locations >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Nomad Navigator' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Nomad Navigator', 2);
    }
    if (locations >= 25 && !state[profile.id]!.any((b) => b['name'] == 'Nomad Navigator' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Nomad Navigator', 3);
    }
    if (locations >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Nomad Navigator' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Nomad Navigator', 4);
    }
    if (locations >= 100 && !state[profile.id]!.any((b) => b['name'] == 'Nomad Navigator' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'Nomad Navigator', 5);
    }

    if (borders >= 1 && !state[profile.id]!.any((b) => b['name'] == 'Globe Trotter' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Globe Trotter', 1);
    }
    if (borders >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Globe Trotter' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Globe Trotter', 2);
    }
    if (borders >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Globe Trotter' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Globe Trotter', 3);
    }
    if (borders >= 20 && !state[profile.id]!.any((b) => b['name'] == 'Globe Trotter' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Globe Trotter', 4);
    }
    if (borders >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Globe Trotter' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'Globe Trotter', 5);
    }

    if (trails >= 1 && !state[profile.id]!.any((b) => b['name'] == 'Pathfinder' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Pathfinder', 1);
    }
    if (trails >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Pathfinder' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Pathfinder', 2);
    }
    if (trails >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Pathfinder' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Pathfinder', 3);
    }
    if (trails >= 20 && !state[profile.id]!.any((b) => b['name'] == 'Pathfinder' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Pathfinder', 4);
    }
    if (trails >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Pathfinder' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'Pathfinder', 5);
    }
  }

  Future<void> _checkCampingBadges(Profile profile) async {
    final campingNights = profile.campingNights ?? 0;
    final stealthNights = profile.stealthCampingNights ?? 0;
    final noKnockCount = profile.noKnockCount ?? 0;
    final urbanNights = profile.urbanSleepingNights ?? 0;
    final wildernessNights = profile.wildernessSleepingNights ?? 0;

    if (campingNights >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Campfire King' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Campfire King', 1);
    }
    if (campingNights >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Campfire King' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Campfire King', 2);
    }
    if (campingNights >= 100 && !state[profile.id]!.any((b) => b['name'] == 'Campfire King' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Campfire King', 3);
    }

    if (stealthNights >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Stealth Camper' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Stealth Camper', 1);
    }
    if (stealthNights >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Stealth Camper' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Stealth Camper', 2);
    }
    if (stealthNights >= 25 && !state[profile.id]!.any((b) => b['name'] == 'Stealth Camper' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Stealth Camper', 3);
    }
    if (stealthNights >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Stealth Camper' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Stealth Camper', 4);
    }
    if (stealthNights >= 100 && !state[profile.id]!.any((b) => b['name'] == 'Stealth Camper' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'Stealth Camper', 5);
    }

    if (noKnockCount >= 5 && !state[profile.id]!.any((b) => b['name'] == 'No-Knock Nomad' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'No-Knock Nomad', 1);
    }
    if (noKnockCount >= 10 && !state[profile.id]!.any((b) => b['name'] == 'No-Knock Nomad' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'No-Knock Nomad', 2);
    }
    if (noKnockCount >= 25 && !state[profile.id]!.any((b) => b['name'] == 'No-Knock Nomad' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'No-Knock Nomad', 3);
    }
    if (noKnockCount >= 50 && !state[profile.id]!.any((b) => b['name'] == 'No-Knock Nomad' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'No-Knock Nomad', 4);
    }
    if (noKnockCount >= 100 && !state[profile.id]!.any((b) => b['name'] == 'No-Knock Nomad' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'No-Knock Nomad', 5);
    }

    if (urbanNights >= 1 && !state[profile.id]!.any((b) => b['name'] == 'Urban Survivor' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Urban Survivor', 1);
    }
    if (urbanNights >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Urban Survivor' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Urban Survivor', 2);
    }
    if (urbanNights >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Urban Survivor' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Urban Survivor', 3);
    }
    if (urbanNights >= 20 && !state[profile.id]!.any((b) => b['name'] == 'Urban Survivor' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Urban Survivor', 4);
    }
    if (urbanNights >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Urban Survivor' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'Urban Survivor', 5);
    }

    if (wildernessNights >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Wilderness Sleeper' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Wilderness Sleeper', 1);
    }
    if (wildernessNights >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Wilderness Sleeper' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Wilderness Sleeper', 2);
    }
  }

  Future<void> _checkOutdoorActivityBadges(Profile profile) async {
    final stargazingNights = profile.stargazingNights ?? 0;
    final peaksClimbed = profile.peaksClimbed ?? 0;
    final kayakingMiles = profile.kayakingMiles ?? 0;
    final fishCaught = profile.fishCaught ?? 0;
    final plantsForaged = profile.plantsForaged ?? 0;

    if (stargazingNights >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Stargazer' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Stargazer', 1);
    }
    if (stargazingNights >= 20 && !state[profile.id]!.any((b) => b['name'] == 'Stargazer' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Stargazer', 2);
    }
    if (stargazingNights >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Stargazer' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Stargazer', 3);
    }

    if (peaksClimbed >= 1 && !state[profile.id]!.any((b) => b['name'] == 'Mountain Master' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Mountain Master', 1);
    }
    if (peaksClimbed >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Mountain Master' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Mountain Master', 2);
    }
    if (peaksClimbed >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Mountain Master' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Mountain Master', 3);
    }
    if (peaksClimbed >= 20 && !state[profile.id]!.any((b) => b['name'] == 'Mountain Master' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Mountain Master', 4);
    }
    if (peaksClimbed >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Mountain Master' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'Mountain Master', 5);
    }

    if (kayakingMiles >= 10 && !state[profile.id]!.any((b) => b['name'] == 'River Runner' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'River Runner', 1);
    }
    if (kayakingMiles >= 50 && !state[profile.id]!.any((b) => b['name'] == 'River Runner' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'River Runner', 2);
    }
    if (kayakingMiles >= 100 && !state[profile.id]!.any((b) => b['name'] == 'River Runner' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'River Runner', 3);
    }

    if (fishCaught >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Fisherman' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Fisherman', 1);
    }
    if (fishCaught >= 20 && !state[profile.id]!.any((b) => b['name'] == 'Fisherman' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Fisherman', 2);
    }
    if (fishCaught >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Fisherman' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Fisherman', 3);
    }
    if (fishCaught >= 100 && !state[profile.id]!.any((b) => b['name'] == 'Fisherman' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Fisherman', 4);
    }

    if (plantsForaged >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Forager' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Forager', 1);
    }
    if (plantsForaged >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Forager' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Forager', 2);
    }
    if (plantsForaged >= 25 && !state[profile.id]!.any((b) => b['name'] == 'Forager' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Forager', 3);
    }
    if (plantsForaged >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Forager' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Forager', 4);
    }
    if (plantsForaged >= 100 && !state[profile.id]!.any((b) => b['name'] == 'Forager' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'Forager', 5);
    }
  }

  Future<void> _checkCommunityBadges(Profile profile) async {
    final followers = profile.followers ?? 0;
    final storiesPosted = profile.storiesPosted ?? 0;
    final cleanups = profile.cleanups ?? 0;
    final toursLed = profile.toursLed ?? 0;
    final forumPosts = profile.forumPosts ?? 0;

    if (followers >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Social Butterfly' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Social Butterfly', 1);
    }
    if (followers >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Social Butterfly' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Social Butterfly', 2);
    }
    if (followers >= 100 && !state[profile.id]!.any((b) => b['name'] == 'Social Butterfly' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Social Butterfly', 3);
    }
    if (followers >= 500 && !state[profile.id]!.any((b) => b['name'] == 'Social Butterfly' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Social Butterfly', 4);
    }
    if (followers >= 1000 && !state[profile.id]!.any((b) => b['name'] == 'Social Butterfly' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'Social Butterfly', 5);
    }

    if (storiesPosted >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Storyteller' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Storyteller', 1);
    }
    if (storiesPosted >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Storyteller' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Storyteller', 2);
    }
    if (storiesPosted >= 100 && !state[profile.id]!.any((b) => b['name'] == 'Storyteller' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Storyteller', 3);
    }
    if (storiesPosted >= 500 && !state[profile.id]!.any((b) => b['name'] == 'Storyteller' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Storyteller', 4);
    }
    if (storiesPosted >= 1000 && !state[profile.id]!.any((b) => b['name'] == 'Storyteller' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'Storyteller', 5);
    }

    if (cleanups >= 1 && !state[profile.id]!.any((b) => b['name'] == 'Eco Warrior' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Eco Warrior', 1);
    }
    if (cleanups >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Eco Warrior' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Eco Warrior', 2);
    }
    if (cleanups >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Eco Warrior' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Eco Warrior', 3);
    }

    if (toursLed >= 1 && !state[profile.id]!.any((b) => b['name'] == 'Guide Guru' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Guide Guru', 1);
    }
    if (toursLed >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Guide Guru' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Guide Guru', 2);
    }
    if (toursLed >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Guide Guru' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Guide Guru', 3);
    }
    if (toursLed >= 20 && !state[profile.id]!.any((b) => b['name'] == 'Guide Guru' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Guide Guru', 4);
    }
    if (toursLed >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Guide Guru' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'Guide Guru', 5);
    }

    if (forumPosts >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Forum Friend' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Forum Friend', 1);
    }
    if (forumPosts >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Forum Friend' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Forum Friend', 2);
    }
  }

  Future<void> _checkMarketplaceBadges(Profile profile) async {
    final itemsSold = profile.itemsSold ?? 0;
    final stickersSold = profile.stickersSold ?? 0;
    final trades = profile.tradesCompleted ?? 0;
    final reviews = profile.reviewsWritten ?? 0;
    final sponsorships = profile.sponsorships ?? 0;

    if (itemsSold >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Gear Collector' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Gear Collector', 1);
    }
    if (itemsSold >= 20 && !state[profile.id]!.any((b) => b['name'] == 'Gear Collector' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Gear Collector', 2);
    }
    if (itemsSold >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Gear Collector' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Gear Collector', 3);
    }

    if (stickersSold >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Sticker Star' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Sticker Star', 1);
    }
    if (stickersSold >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Sticker Star' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Sticker Star', 2);
    }
    if (stickersSold >= 25 && !state[profile.id]!.any((b) => b['name'] == 'Sticker Star' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Sticker Star', 3);
    }
    if (stickersSold >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Sticker Star' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Sticker Star', 4);
    }
    if (stickersSold >= 100 && !state[profile.id]!.any((b) => b['name'] == 'Sticker Star' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'Sticker Star', 5);
    }

    if (trades >= 1 && !state[profile.id]!.any((b) => b['name'] == 'Trader' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Trader', 1);
    }
    if (trades >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Trader' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Trader', 2);
    }
    if (trades >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Trader' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Trader', 3);
    }
    if (trades >= 20 && !state[profile.id]!.any((b) => b['name'] == 'Trader' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Trader', 4);
    }
    if (trades >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Trader' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'Trader', 5);
    }

    if (reviews >= 1 && !state[profile.id]!.any((b) => b['name'] == 'Gear Reviewer' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Gear Reviewer', 1);
    }
    if (reviews >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Gear Reviewer' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Gear Reviewer', 2);
    }
    if (reviews >= 10 && !state[profile.id]!.any((b) => b['name'] == 'Gear Reviewer' && b['level'] == 3)) {
      await _awardBadge(profile.id, 'Gear Reviewer', 3);
    }
    if (reviews >= 20 && !state[profile.id]!.any((b) => b['name'] == 'Gear Reviewer' && b['level'] == 4)) {
      await _awardBadge(profile.id, 'Gear Reviewer', 4);
    }
    if (reviews >= 50 && !state[profile.id]!.any((b) => b['name'] == 'Gear Reviewer' && b['level'] == 5)) {
      await _awardBadge(profile.id, 'Gear Reviewer', 5);
    }

    if (sponsorships >= 1 && !state[profile.id]!.any((b) => b['name'] == 'Sponsor Scout' && b['level'] == 1)) {
      await _awardBadge(profile.id, 'Sponsor Scout', 1);
    }
    if (sponsorships >= 5 && !state[profile.id]!.any((b) => b['name'] == 'Sponsor Scout' && b['level'] == 2)) {
      await _awardBadge(profile.id, 'Sponsor Scout', 2);
    }
  }
  
  Future<void> _updateVerificationAndFlair(int profileId) async {
		final badges = state[profileId] ?? [];
		final subscription = _ref.read(subscriptionProvider)[profileId];
		final profile = _ref.read(profileProvider).firstWhere((p) => p.id == profileId);

		// Verification criteria: 10+ badges or Elite subscription
		final isVerified = badges.length >= 10 || subscription == 'elite';
		String? flairIcon;

		// Assign flair based on highest-level badge
		if (badges.any((b) => b['name'] == 'Elite Global Influencer' && b['level'] >= 2)) {
		  flairIcon = '🌟'; // Elite Influencer
		} else if (badges.any((b) => b['name'] == 'Pro Challenge Champion' && b['level'] >= 2)) {
		  flairIcon = '🏆'; // Pro Champion
		} else if (badges.any((b) => b['name'] == 'Basic Event Enthusiast' && b['level'] >= 2)) {
		  flairIcon = '🎉'; // Basic Enthusiast
		} else if (badges.any((b) => b['name'] == 'Trailblazer' && b['level'] >= 5)) {
		  flairIcon = '🏔️'; // Top Trailblazer
		} else if (badges.any((b) => b['name'] == 'Social Butterfly' && b['level'] >= 5)) {
		  flairIcon = '🦋'; // Top Social Butterfly
		}

		await _supabase.from('profiles').update({
		  'is_verified': isVerified,
		  'flair_icon': flairIcon,
		}).eq('id', profileId);

		final updatedProfile = profile.copyWithDynamic('is_verified', isVerified).copyWithDynamic('flair_icon', flairIcon);
		_ref.read(profileProvider.notifier).updateProfile(updatedProfile);
	}

	// Call this in _awardBadge
	Future<void> _awardBadge(int profileId, String name, int level) async {
		await _supabase.from('badges').insert({
		  'profile_id': profileId,
		  'name': name,
		  'level': level,
		  'earned_date': DateTime.now().toIso8601String(),
		  'is_premium': name.contains('Elite') || name.contains('Pro') || name.contains('Basic'),
		});
		await loadBadges(profileId);
		await _updateVerificationAndFlair(profileId);

		await _supabase.from('notifications').insert({
		  'profile_id': profileId,
		  'type': 'badge',
		  'content': 'You earned the $name (Level $level) badge!',
		  'timestamp': DateTime.now().toIso8601String(),
		  'is_read': false,
		});
		_ref.read(notificationProvider.notifier).loadNotifications();
	}
  
}

final badgeProvider = StateNotifierProvider.family<BadgeNotifier, Map<int, List<Map<String, dynamic>>>, int>((ref, profileId) {
  final notifier = BadgeNotifier(ref);
  notifier.loadBadges(profileId);
  return notifier;
});
