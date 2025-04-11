import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../models/forum_post.dart';

class ForumNotifier extends StateNotifier<List<ForumPost>> {
  final DatabaseHelper _dbHelper;

  ForumNotifier(this._dbHelper) : super([]) {
    loadPosts();
  }

  Future<void> loadPosts() async {
    final maps = await _dbHelper.getForumPosts();
    state = maps.map((map) => ForumPost.fromMap(map)).toList();
  }

  Future<void> addPost(ForumPost post) async {
    final newPostMap = await _dbHelper.createForumPost(post.toMap());
    final newPost = ForumPost.fromMap(newPostMap);
    state = [...state, newPost];
  }

  Future<void> upvotePost(int postId, int profileId) async {
    await _dbHelper.upvoteForumPost(postId, profileId);
    state = [
      for (final p in state)
        p.id == postId ? p.copyWith(upvotes: p.upvotes + 1) : p,
    ];
  }

  Future<void> downvotePost(int postId, int profileId) async {
    await _dbHelper.downvoteForumPost(postId, profileId);
    state = [
      for (final p in state)
        p.id == postId ? p.copyWith(downvotes: p.downvotes + 1) : p,
    ];
  }
}

final forumProvider = StateNotifierProvider<ForumNotifier, List<ForumPost>>((ref) {
  return ForumNotifier(DatabaseHelper());
});
