import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../models/post.dart';

class PostNotifier extends StateNotifier<List<Post>> {
  final DatabaseHelper _dbHelper;
  final supabase = Supabase.instance.client;

  PostNotifier(this._dbHelper) : super([]) {
    loadPosts();
  }

  Future<void> loadPosts() async {
    final maps = await _dbHelper.getPosts();
    final remotePosts = await supabase.from('posts').select();
    state = maps.map((map) => Post.fromMap(map)).toList();
  }

  Future<void> addPost(Post post) async {
    final newPostMap = await _dbHelper.createPost(post.toMap());
    final newPost = Post.fromMap(newPostMap);
    state = [...state, newPost];
  }

  Future<void> updatePost(Post post) async {
    await _dbHelper.updatePost(post.toMap());
    state = [
      for (final p in state)
        p.id == post.id ? post : p,
    ];
  }

  Future<void> deletePost(int id) async {
    await _dbHelper.deletePost(id);
    state = state.where((p) => p.id != id).toList();
  }

  Future<void> likePost(int postId, int profileId) async {
    await _dbHelper.likePost(postId, profileId);
    state = [
      for (final p in state)
        p.id == postId ? p.copyWith(likes: p.likes + 1) : p,
    ];
  }

  Future<void> unlikePost(int postId, int profileId) async {
    await _dbHelper.unlikePost(postId, profileId);
    state = [
      for (final p in state)
        p.id == postId ? p.copyWith(likes: p.likes - 1) : p,
    ];
  }

  Future<void> sharePost(int postId, int profileId) async {
    await _dbHelper.sharePost(postId, profileId);
    state = [
      for (final p in state)
        p.id == postId ? p.copyWith(shares: (p.shares ?? 0) + 1) : p,
    ];
  }

  Future<bool> isLiked(int postId, int profileId) async {
    return await _dbHelper.isLiked(postId, profileId);
  }
}

final postProvider = StateNotifierProvider<PostNotifier, List<Post>>((ref) {
  return PostNotifier(DatabaseHelper());
});
