import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/database.dart';
import '../models/listing.dart';

class ListingNotifier extends StateNotifier<List<Listing>> {
  final DatabaseHelper _dbHelper;
  final _supabase = Supabase.instance.client;

  ListingNotifier(this._dbHelper) : super([]) {
    loadListings();
  }

  Future<void> loadListings() async {
    final maps = await _dbHelper.getListings();
    state = maps.map((map) => Listing.fromMap(map)).toList();

    final remoteListings = await _supabase.from('listings').select();
    state = remoteListings.map((map) => Listing.fromMap(map)).toList();
  }

  Future<void> addListing(Listing listing) async {
    final newListingMap = await _dbHelper.createListing(listing.toMap());
    final newListing = Listing.fromMap(newListingMap);
    state = [...state, newListing];
    await _supabase.from('listings').insert(newListing.toMap());
  }

  Future<void> updateListing(Listing listing) async {
    await _dbHelper.updateListing(listing.toMap());
    await _supabase.from('listings').update(listing.toMap()).eq('id', listing.id);
    state = [for (final l in state) l.id == listing.id ? listing : l];
  }
}

final listingProvider = StateNotifierProvider<ListingNotifier, List<Listing>>((ref) {
  return ListingNotifier(DatabaseHelper());
});
