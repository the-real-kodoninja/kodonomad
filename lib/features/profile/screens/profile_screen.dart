import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/profile.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/providers/post_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../badges/providers/badge_provider.dart';
import '../../feed/widgets/post_card.dart';
import '../../follows/screens/followers_screen.dart';
import '../../follows/screens/following_screen.dart';
import '../../follows/providers/follow_provider.dart';
import '../../subscriptions/screens/subscription_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profileProvider);
    final myId = 1; // Replace with actual user ID
    final myProfile = profiles.firstWhere((p) => p.id == myId, orElse: () => Profile(id: myId, username: 'NomadUser', milesTraveled: 0));
    final posts = ref.watch(postProvider);
    final badges = ref.watch(badgeProvider(myId));
    final subscription = ref.watch(subscriptionProvider)[myId];
    final follows = ref.watch(followProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          DropdownButton<String>(
            value: ref.watch(themeProvider),
            items: ref.read(themeProvider.notifier).themes.keys.map((theme) {
              return DropdownMenuItem(value: theme, child: Text(theme));
            }).toList(),
            onChanged: (value) {
              if (value == 'Elite Nomad' && subscription != 'elite') {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Elite Nomad theme is for Elite subscribers only!')));
                return;
              }
              if (value != null) {
                ref.read(themeProvider.notifier).setTheme(value);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: const NetworkImage('https://via.placeholder.com/150'),
                  ),
                  const SizedBox(height: 16),
                  Text(myProfile.username, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Miles Traveled: ${myProfile.milesTraveled}', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            // Stats
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                    label: 'Posts',
                    value: posts.where((p) => p.profileId == myId).length.toString(),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FollowersScreen(profileId: myId))),
                    child: _StatItem(label: 'Followers', value: myProfile.followers?.toString() ?? '0'),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FollowingScreen(profileId: myId))),
                    child: _StatItem(label: 'Following', value: follows[myId]?.length.toString() ?? '0'),
                  ),
                  _StatItem(label: 'Miles', value: myProfile.milesTraveled.toString()),
                ],
              ),
            ),
            // Subscription Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen())),
                child: const Text('Manage Subscription'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              ),
            ),
            // Analytics Button
            Padding(
							padding: const EdgeInsets.all(16),
							child: ElevatedButton(
								onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyticsScreen())),
								child: const Text('View Analytics'),
								style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
							),
						),
            // Badges
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Badges', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (badges[myId] != null)
                    Wrap(
                      spacing: 8,
                      children: badges[myId]!.map((badge) {
                        return Chip(label: Text('${badge['name']} (Level ${badge['level']})'));
                      }).toList(),
                    )
                  else
                    const Text('No badges yet!'),
                ],
              ),
            ),
            // Posts
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Posts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...posts.where((p) => p.profileId == myId).map((post) => PostCard(post: post)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
