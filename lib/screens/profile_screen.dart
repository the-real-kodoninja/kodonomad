import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/profile_provider.dart';
import '../providers/post_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/post_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen();
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profiles = ref.watch(profileProvider);
    final posts = ref.watch(postProvider);
    final themeAsync = ref.watch(themeProvider);
    final myProfile = profiles.isNotEmpty ? profiles.first : null;
    final myId = myProfile?.id ?? 1;

    return myProfile == null
        ? const Center(child: Text('No Profile Yet'))
        : themeAsync.when(
            data: (themeProvider) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(profile: myProfile),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(
                          label: 'Posts',
                          value: posts.where((p) => p.profileId == myId).length.toString(),
                        ),
                        const _StatItem(label: 'Followers', value: '420'),
                        const _StatItem(label: 'Following', value: '69'),
                        _StatItem(label: 'Miles', value: myProfile.milesTraveled.toString()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Theme', style: Theme.of(context).textTheme.titleLarge),
                        DropdownButton<String>(
                          value: themeProvider.themeNames.firstWhere(
                            (name) => themeProvider._themes[name] == themeProvider.currentTheme,
                            orElse: () => 'Desert Sunset',
                          ),
                          items: themeProvider.themeNames
                              .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              themeProvider.setTheme(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
		  padding: const EdgeInsets.all(16),
		  child: ElevatedButton(
		    onPressed: () {
		      if (myProfile?.walletAddress != null) {
			// Handle crypto donation
		      } else if (myProfile?.stripeId != null || myProfile?.paypalId != null) {
			// Handle Stripe/PayPal donation
		      } else {
			ScaffoldMessenger.of(context).showSnackBar(
			  const SnackBar(content: Text('Please add a donation method in settings')),
			);
		      }
		    },
		    child: const Text('Donate to Me'),
		    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
		  ),
		),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Badges', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  _BadgeGrid(),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Recent Posts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ...posts.where((p) => p.profileId == myId).take(3).map((post) => PostCard(post: post)),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => UserPostsScreen(profileId: myId)),
                        );
                      },
                      child: const Text('See All Posts'),
                      style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
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
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _BadgeGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profileProvider);
    final myId = profiles.isNotEmpty ? profiles.first.id : 1;
    final badges = ref.watch(badgeProvider(myId));
    return SizedBox(
      height: 100,
      child: badges.when(
        data: (badgeList) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: badgeList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chip(
                label: Text(badgeList[index]['name']),
                avatar: Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Error: $e'),
      ),
    );
  }
}

class UserPostsScreen extends ConsumerWidget {
  final int profileId;

  const UserPostsScreen({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postProvider);
    final userPosts = posts.where((p) => p.profileId == profileId).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('All Posts')),
      body: ListView.builder(
        itemCount: userPosts.length,
        itemBuilder: (context, index) => PostCard(post: userPosts[index]),
      ),
    );
  }
}

final badgeProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, profileId) async {
  return await supabase.instance.client.from('badges').select().eq('profile_id', profileId);
});
