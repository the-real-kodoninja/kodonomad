import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../models/listing.dart';

class ListingNotifier extends StateNotifier<List<Listing>> {
  final DatabaseHelper _dbHelper;

  ListingNotifier(this._dbHelper) : super([]) {
    _loadListings();
  }

  Future<void> _loadListings() async {
    state = await _dbHelper.getListings();
  }

  Future<void> addListing(Listing listing) async {
    final newListing = await _dbHelper.createListing(listing);
    state = [...state, newListing];
  }

  Future<void> updateListing(Listing listing) async {
    await _dbHelper.updateListing(listing);
    state = [
      for (final l in state)
        l.id == listing.id ? listing : l,
    ];
  }

  Future<void> deleteListing(int id) async {
    await _dbHelper.deleteListing(id);
    state = state.where((l) => l.id != id).toList();
  }
}

final listingProvider = StateNotifierProvider<ListingNotifier, List<Listing>>((ref) {
  return ListingNotifier(DatabaseHelper.instance);
});
