import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/listing.dart';

class CartNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final _supabase = Supabase.instance.client;

  CartNotifier() : super([]) {
    loadCart(1); // Assume profileId 1 for now
  }

  Future<void> loadCart(int profileId) async {
    state = await _supabase.from('cart').select('*, listings(*)').eq('profile_id', profileId);
  }

  Future<void> addToCart(int profileId, int listingId) async {
    final existing = state.firstWhere((item) => item['listing_id'] == listingId, orElse: () => {});
    if (existing.isEmpty) {
      final newItem = await _supabase.from('cart').insert({'profile_id': profileId, 'listing_id': listingId}).select().single();
      state = [...state, newItem];
    }
  }

  Future<void> removeFromCart(int cartId) async {
    await _supabase.from('cart').delete().eq('id', cartId);
    state = state.where((item) => item['id'] != cartId).toList();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<Map<String, dynamic>>>((ref) => CartNotifier());
