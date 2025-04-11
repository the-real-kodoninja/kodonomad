import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../providers/post_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/post_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profiles = ref.watch(profileProvider);
    final posts = ref.watch(postProvider);
    final myProfile = profiles.isNotEmpty ? profiles.first : null;
    final myId = myProfile?.id ?? 1;

        return myProfile == null
        ? Center(child: Text('No Profile Yet'))
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(profile: myProfile),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(
                          label: 'Posts',
                          value: posts.where((p) => p.profileId == myId).length.toString()),
                      _StatItem(label: 'Followers', value: '420'), // Update with real count
                      _StatItem(label: 'Following', value: '69'), // Update with real count
                      _StatItem(label: 'Miles', value: myProfile.milesTraveled.toString()),
                    ],
                  ),
                ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Badges', style: Theme.of(context).textTheme.titleLarge),
                    ),
                    _BadgeGrid(),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Recent Posts', style: Theme.of(context).textTheme.titleLarge),
                    ),
                    ...posts
                        .where((p) => p.profileId == myId)
                        .take(3)
                        .map((post) => PostCard(post: post)),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => UserPostsScreen(profileId: myId)),
                          );
                        },
                        child: Text('See All Posts'),
                        style: OutlinedButton.styleFrom(minimumSize: Size(double.infinity, 48)),
                      ),
                    ),
                  ],
                ),
              );
      },
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
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Chip(
              label: Text(badges[index]['name']),
              avatar: Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
            ),
          );
        },
      ),
    );
  }
}

final badgeProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, profileId) async {
  return await DatabaseHelper().getBadges(profileId);
});

class UserPostsScreen extends ConsumerWidget {
  final int profileId;

  const UserPostsScreen({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postProvider).where((p) => p.profileId == profileId).toList();
    return Scaffold(
      appBar: AppBar(title: Text('My Posts')),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCard(post: posts[index]);
        },
      ),
    );
  }
}
