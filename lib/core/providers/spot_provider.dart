import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/database.dart';
import '../models/profile.dart';
import '../services/crypto_service.dart';

class ProfileNotifier extends StateNotifier<List<Profile>> {
  final DatabaseHelper _dbHelper;
  final _supabase = Supabase.instance.client;

  ProfileNotifier(this._dbHelper) : super([]) {
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    final maps = await _dbHelper.getProfiles();
    state = maps.map((map) => Profile.fromMap(map)).toList();

    final remoteProfiles = await _supabase.from('profiles').select();
    state = remoteProfiles.map((map) => Profile.fromMap(map)).toList();
  }

  Future<void> updateMiles(int profileId, int miles) async {
    await _dbHelper.updateMiles(profileId, miles);
    await _supabase.from('profiles').update({'miles_traveled': miles}).eq('id', profileId);
    state = [for (final p in state) p.id == profileId ? p.copyWith(milesTraveled: miles) : p];
    ref.read(cryptoServiceProvider).rewardCrypto(profileId, miles);
    if (miles % 1000 == 0) {
      ref.read(cryptoServiceProvider).mintNFT(profileId, '{"name": "Milestone NFT", "miles": $miles}');
    }
  }

  Future<void> updateProfile(Profile profile) async {
    await _dbHelper.updateProfile(profile.toMap());
    await _supabase.from('profiles').update(profile.toMap()).eq('id', profile.id);
    state = [for (final p in state) p.id == profile.id ? profile : p];
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, List<Profile>>((ref) {
  return ProfileNotifier(DatabaseHelper());
});
