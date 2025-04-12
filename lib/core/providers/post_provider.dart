import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/database.dart';
import '../models/post.dart';

class PostNotifier extends StateNotifier<List<Post>> {
  final DatabaseHelper _dbHelper;
  final _supabase = Supabase.instance.client;

  PostNotifier(this._dbHelper) : super([]) {
    loadPosts();
  }

  Future<void> loadPosts() async {
  final localMaps = await _dbHelper.getPosts();
  final remotePosts = await _supabase.from('posts').select();
  state = remotePosts.map((map) => Post.fromMap(map)).toList();
  for (var post in localMaps) {
    if (!remotePosts.any((r) => r['id'] == post['id'])) {
      await _supabase.from('posts').insert(post);
    }
  }
}

  Future<void> addPost(int profileId, String content, String? imageUrl, String category) async {
    final newPost = await _supabase.from('posts').insert({
      'profile_id': profileId,
      'content': content,
      'image_url': imageUrl,
      'timestamp': DateTime.now().toIso8601String(),
      'category': category,
    }).select().single();
    await _supabase.from('profiles').update({
      'points': _supabase.raw('points + 10'), // 10 points for posting
    }).eq('id', profileId);
    state = [Post.fromMap(newPost), ...state];

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
