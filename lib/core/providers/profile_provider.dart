import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../models/profile.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, List<Profile>>(
  (ref) => ProfileNotifier(),
);

class ProfileNotifier extends StateNotifier<List<Profile>> {
  ProfileNotifier() : super([]) {
    _loadProfiles();
  }

  final _dbHelper = DatabaseHelper.instance;

  Future<void> _loadProfiles() async {
    state = await _dbHelper.getProfiles();
  }

  Future<void> addProfile(Profile profile) async {
    await _dbHelper.createProfile(profile);
    state = [...state, profile];
  }
  
  Future<void> updateMiles(int profileId, int miles) async {
		await _dbHelper.updateMiles(profileId, miles);
		await supabase.instance.client.from('profiles').update({'miles_traveled': miles}).eq('id', profileId);
		state = [for (final p in state) p.id == profileId ? p.copyWith(milesTraveled: miles) : p];
		ref.read(cryptoServiceProvider).rewardCrypto(profileId, miles);
		if (miles % 1000 == 0) {
		  ref.read(cryptoServiceProvider).mintNFT(profileId, '{"name": "Milestone NFT", "miles": $miles}');
		}
	}
}
