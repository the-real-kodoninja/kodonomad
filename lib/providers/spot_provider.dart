import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../models/spot.dart';

class SpotNotifier extends StateNotifier<List<Spot>> {
  final DatabaseHelper _dbHelper;

  SpotNotifier(this._dbHelper) : super([]) {
    _loadSpots();
  }

  Future<void> _loadSpots() async {
    state = await _dbHelper.getSpots();
  }

  Future<void> addSpot(Spot spot) async {
    final newSpot = await _dbHelper.createSpot(spot);
    state = [...state, newSpot];
  }

  Future<void> updateSpot(Spot spot) async {
    await _dbHelper.updateSpot(spot);
    state = [
      for (final s in state)
        s.id == spot.id ? spot : s,
    ];
  }

  Future<void> deleteSpot(int id) async {
    await _dbHelper.deleteSpot(id);
    state = state.where((s) => s.id != id).toList();
  }
}

final spotProvider = StateNotifierProvider<SpotNotifier, List<Spot>>((ref) {
  return SpotNotifier(DatabaseHelper.instance);
});
