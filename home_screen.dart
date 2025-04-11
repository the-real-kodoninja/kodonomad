// [Previous code unchanged until _buildProfile]

  Widget _buildProfile() {
    final profiles = ref.watch(profileProvider);
    final posts = ref.watch(postProvider);
    final myProfile = profiles.isNotEmpty ? profiles.first : null;
    final myId = myProfile?.id ?? 1; // Assume logged-in user ID 1 for now

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
                      _StatItem(label: 'Posts', value: posts.where((p) => p.profileId == myId).length.toString()),
                      _StatItem(label: 'Followers', value: '420'), // Placeholder
                      _StatItem(label: 'Following', value: '69'), // Placeholder
                      _StatItem(label: 'Miles', value: myProfile.milesTraveled.toString()),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () => _editProfile(context),
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

class _BadgeGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder badges
    final badges = ['Nomad Starter', 'Desert Dweller', 'Mile Master'];
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Chip(
              label: Text(badges[index]),
              avatar: Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
            ),
          );
        },
      ),
    );
  }
}

// [PostCard, ListingCard, ProfileHeader unchanged]

// New screen for all user posts
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
