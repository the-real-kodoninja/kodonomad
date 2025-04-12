class AdService {
  Future<void> enableAds(int profileId) async {
    // Enable ads for user
  }

  Future<double> calculateRevenue(int profileId) async {
    final ads = await supabase.instance.client.from('ads').select().eq('profile_id', profileId);
    final total = ads.fold<double>(0, (sum, ad) => sum + (ad['revenue'] as num).toDouble());
    final userShare = total * 0.8; // 80% to user
    // Transfer userShare to user's payment method
    return userShare;
  }
}

final adServiceProvider = Provider((ref) => AdService());
