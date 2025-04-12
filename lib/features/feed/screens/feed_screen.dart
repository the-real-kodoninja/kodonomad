import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/post_provider.dart';
import '../widgets/ad_widget.dart';
import '../widgets/post_card.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen();

  @override
  _FeedScreenState createState() => _FeedScreenState();
}


class _FeedScreenState extends ConsumerState<FeedScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _page = 0;
  final int _limit = 10;
  bool _hasMore = true;
  final List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    _loadMorePosts();
  }

  Future<void> _loadMorePosts() async {
    final newPosts = await _supabase.from('posts').select().range(_page * _limit, (_page + 1) * _limit - 1);
    if (newPosts.length < _limit) {
      _hasMore = false;
    }
    _posts.addAll(newPosts.map((map) => Post.fromMap(map)).toList());
    _page++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final subscription = ref.watch(subscriptionProvider)[1]; // Replace with actual user ID
    final showAds = subscription == null;

    return RefreshIndicator(
      onRefresh: () async {
        _page = 0;
        _posts.clear();
        _hasMore = true;
        await _loadMorePosts();
      },
      child: ListView.builder(
        itemCount: _posts.length + (showAds ? (_posts.length ~/ 3) : 0) + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _posts.length + (showAds ? (_posts.length ~/ 3) : 0)) {
            if (_hasMore) {
              _loadMorePosts();
              return const Center(child: CircularProgressIndicator());
            }
            return const SizedBox.shrink();
          }
          if (showAds && index % 4 == 3) {
            return FadeTransition(
              opacity: _animation,
              child: const AdWidget(),
            );
          }
          final postIndex = index - (showAds ? (index ~/ 4) : 0);
          return FadeTransition(
            opacity: _animation,
            child: PostCard(post: _posts[postIndex]),
          );
        },
      ),
    );
  }
}
