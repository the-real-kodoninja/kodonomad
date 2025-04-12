import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TipNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final _supabase = Supabase.instance.client;

  TipNotifier() : super([]) {
    loadTips();
  }

  Future<void> loadTips() async {
    final data = await _supabase.from('tips').select();
    state = data;
  }

  Future<void> sendTip(int senderId, int receiverId, double amount, String currency) async {
    await _supabase.from('tips').insert({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'amount': amount,
      'currency': currency,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await loadTips();
  }
}

final tipProvider = StateNotifierProvider<TipNotifier, List<Map<String, dynamic>>>((ref) {
  return TipNotifier();
});
