// lib/features/checkins/providers/checkin_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kodonomad/utils/location_service.dart';

class CheckIn {
  final int id;
  final int profileId;
  final String encryptedLocation;
  final String locationName;
  final DateTime timestamp;
  final bool isAutomatic;

  CheckIn({
    required this.id,
    required this.profileId,
    required this.encryptedLocation,
    required this.locationName,
    required this.timestamp,
    required this.isAutomatic,
  });

  factory CheckIn.fromMap(Map<String, dynamic> map) => CheckIn(
        id: map['id'],
        profileId: map['profile_id'],
        encryptedLocation: map['encrypted_location'],
        locationName: map['location_name'],
        timestamp: DateTime.parse(map['timestamp']),
        isAutomatic: map['is_automatic'],
      );
}

class Badge {
  final int id;
  final String name;
  final String description;
  final String icon;
  final int criteria;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.criteria,
  });

  factory Badge.fromMap(Map<String, dynamic> map) => Badge(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        icon: map['icon'],
        criteria: map['criteria'],
      );
}

class CheckInNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final Ref _ref;
  final _supabase = Supabase.instance.client;
  late final RealtimeChannel _channel;

  CheckInNotifier(this._ref) : super(const AsyncValue.loading()) {
    fetchCheckIns();
    _setupRealtime();
  }

  void _setupRealtime() {
    try {
      _channel = _supabase.channel('checkins');
      _channel.on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: '*', schema: 'public', table: 'checkins'),
        (payload, [ref]) {
          fetchCheckIns();
        },
      ).subscribe((status, [error]) {
        if (status == 'SUBSCRIPTION_ERROR' && error != null) {
          state = AsyncValue.error(
            'Failed to subscribe to real-time updates: $error',
            StackTrace.current,
          );
        }
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        'Failed to setup real-time updates: $e',
        stackTrace,
      );
    }
  }

  @override
  void dispose() {
    try {
      _supabase.removeChannel(_channel);
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        'Failed to cleanup real-time channel: $e',
        stackTrace,
      );
    }
    super.dispose();
  }

  Future<void> fetchCheckIns({int page = 0, int limit = 20}) async {
    try {
      state = const AsyncValue.loading();
      final myId = 1; // Replace with actual user ID

      // Fetch user's check-ins with pagination
      final checkInsData = await _supabase
          .from('checkins')
          .select()
          .eq('profile_id', myId)
          .range(page * limit, (page + 1) * limit - 1);
      final newCheckIns = checkInsData.map((map) => CheckIn.fromMap(map)).toList();

      // Fetch badges
      final badgesData = await _supabase.from('badges').select();
      final badges = badgesData.map((map) => Badge.fromMap(map)).toList();

      // Get existing check-ins from state if available
      final existingCheckIns = state.value?['checkIns'] as List<CheckIn>? ?? [];

      // Combine new and existing check-ins
      final allCheckIns = page == 0 ? newCheckIns : [...existingCheckIns, ...newCheckIns];

      // Calculate earned badges
      final uniqueLocations = allCheckIns.map((c) => c.locationName).toSet().length;
      final earnedBadges = badges.where((b) => uniqueLocations >= b.criteria).toList();

      state = AsyncValue.data({
        'checkIns': allCheckIns,
        'badges': badges,
        'earnedBadges': earnedBadges,
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        'Failed to fetch check-ins: $e',
        stackTrace,
      );
    }
  }

  Future<void> checkIn(String locationName) async {
    try {
      final myId = 1; // Replace with actual user ID
      final locationData = await LocationService.getCurrentLocation();
      await _supabase.from('checkins').insert({
        'profile_id': myId,
        'encrypted_location': locationData['encrypted'],
        'location_name': locationName,
        'is_automatic': false,
      });
      await fetchCheckIns();
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        'Failed to check in: $e',
        stackTrace,
      );
    }
  }

  Future<void> autoCheckIn() async {
    try {
      final myId = 1; // Replace with actual user ID
      final locationData = await LocationService.getCurrentLocation();
      final nearbySpots = await LocationService.fetchNearbySpots(locationData['encrypted']);
      if (nearbySpots.isNotEmpty) {
        final closestSpot = nearbySpots.first;
        final distance = double.parse(closestSpot['distance'].split(' ')[0]);
        if (distance < 100) { // Check in if within 100 meters
          await _supabase.from('checkins').insert({
            'profile_id': myId,
            'encrypted_location': locationData['encrypted'],
            'location_name': closestSpot['name'],
            'is_automatic': true,
          });
          await fetchCheckIns();
        }
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        'Failed to auto check-in: $e',
        stackTrace,
      );
    }
  }
}

final checkInProvider = StateNotifierProvider<CheckInNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  return CheckInNotifier(ref);
});
