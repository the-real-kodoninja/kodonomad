import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscriptionNotifier extends StateNotifier<Map<int, String>> {
  final _supabase = Supabase.instance.client;

  SubscriptionNotifier() : super({}) {
    loadSubscriptions();
  }

  Future<void> loadSubscriptions() async {
    final data = await _supabase.from('subscriptions').select().eq('status', 'active');
    final subsMap = <int, String>{};
    for (var sub in data) {
      subsMap[sub['profile_id']] = sub['tier'];
    }
    state = subsMap;
  }

  Future<void> subscribe(int profileId, String tier) async {
    await _supabase.from('subscriptions').insert({
      'profile_id': profileId,
      'tier': tier,
      'start_date': DateTime.now().toIso8601String(),
      'end_date': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      'status': 'active',
    });
    state = {...state, profileId: tier};
  }

  Future<void> cancelSubscription(int profileId) async {
    await _supabase.from('subscriptions').update({'status': 'canceled'}).eq('profile_id', profileId).eq('status', 'active');
    state = {...state}..remove(profileId);
  }
}

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, Map<int, String>>((ref) {
  return SubscriptionNotifier();
});
