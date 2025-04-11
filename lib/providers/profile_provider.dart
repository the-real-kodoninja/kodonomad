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
}
