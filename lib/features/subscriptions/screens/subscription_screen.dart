import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/profile_provider.dart';
import '../providers/subscription_provider.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profileProvider);
    final myProfile = profiles.isNotEmpty ? profiles.first : null;
    final myId = myProfile?.id ?? 1;
    final subscription = ref.watch(subscriptionProvider)[myId];

    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subscription != null) ...[
              Text('Current Plan: $subscription', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(subscriptionProvider.notifier).cancelSubscription(myId),
                child: const Text('Cancel Subscription'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              ),
            ],
            if (subscription == null) ...[
              const Text('Choose a Plan:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _PlanCard(
                tier: 'Basic',
                price: '\$5/month',
                benefits: ['Exclusive Badges', 'Ad-Free Experience'],
                onSubscribe: () => ref.read(subscriptionProvider.notifier).subscribe(myId, 'basic'),
              ),
              _PlanCard(
                tier: 'Pro',
                price: '\$10/month',
                benefits: ['Exclusive Badges', 'Ad-Free Experience', 'Premium Themes', 'Analytics Dashboard'],
                onSubscribe: () => ref.read(subscriptionProvider.notifier).subscribe(myId, 'pro'),
              ),
              _PlanCard(
                tier: 'Elite',
                price: '\$20/month',
                benefits: ['All Pro Benefits', 'Priority Support', 'Exclusive Events', 'NFT Rewards'],
                onSubscribe: () => ref.read(subscriptionProvider.notifier).subscribe(myId, 'elite'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String tier;
  final String price;
  final List<String> benefits;
  final VoidCallback onSubscribe;

  const _PlanCard({required this.tier, required this.price, required this.benefits, required this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tier, style: Theme.of(context).textTheme.titleLarge),
                Text(price, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            ...benefits.map((benefit) => Text('• $benefit')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onSubscribe,
              child: const Text('Subscribe'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            ),
          ],
        ),
      ),
    );
  }
}
