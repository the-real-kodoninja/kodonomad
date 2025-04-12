import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kodonomad/core/models/post.dart';

class PostNotifier extends StateNotifier<List<Post>> {
  final _supabase = Supabase.instance.client;
  final Ref _ref;

  PostNotifier(this._ref) : super([]) {
    loadPosts();
  }

  Future<void> loadPosts() async {
    final data = await _supabase.from('posts').select();
    state = data.map((map) => Post.fromMap(map)).toList();
  }

  Future<bool> isLiked(int postId, int profileId) async {
    final data = await _supabase
        .from('post_interactions')
        .select()
        .eq('post_id', postId)
        .eq('profile_id', profileId)
        .eq('interaction_type', 'like');
    return data.isNotEmpty;
  }

  Future<void> likePost(int postId, int profileId) async {
    final post = state.firstWhere((p) => p.id == postId);
    await _supabase.from('posts').update({'likes': (post.likes ?? 0) + 1}).eq('id', postId);
    await _supabase.from('post_interactions').insert({
      'post_id': postId,
      'profile_id': profileId,
      'interaction_type': 'like',
      'timestamp': DateTime.now().toIso8601String(),
    });
    state = [
      for (var p in state)
        if (p.id == postId) p.copyWith(likes: (p.likes ?? 0) + 1) else p,
    ];
  }

  Future<void> unlikePost(int postId, int profileId) async {
    final post = state.firstWhere((p) => p.id == postId);
    await _supabase.from('posts').update({'likes': (post.likes ?? 0) - 1}).eq('id', postId);
    await _supabase
        .from('post_interactions')
        .delete()
        .eq('post_id', postId)
        .eq('profile_id', profileId)
        .eq('interaction_type', 'like');
    state = [
      for (var p in state)
        if (p.id == postId) p.copyWith(likes: (p.likes ?? 0) - 1) else p,
    ];
  }

  Future<void> sharePost(int postId, int profileId) async {
    final post = state.firstWhere((p) => p.id == postId);
    await _supabase.from('posts').update({'shares': (post.shares ?? 0) + 1}).eq('id', postId);
    await _supabase.from('post_interactions').insert({
      'post_id': postId,
      'profile_id': profileId,
      'interaction_type': 'share',
      'timestamp': DateTime.now().toIso8601String(),
    });
    state = [
      for (var p in state)
        if (p.id == postId) p.copyWith(shares: (p.shares ?? 0) + 1) else p,
    ];
  }

  Future<void> addPost(int profileId, String content, String? imageUrl, String category) async {
    final newPost = await _supabase.from('posts').insert({
      'profile_id': profileId,
      'content': content,
      'image_url': imageUrl,
      'timestamp': DateTime.now().toIso8601String(),
      'category': category,
    }).select().single();
    state = [Post.fromMap(newPost), ...state];
  }
}

final postProvider = StateNotifierProvider<PostNotifier, List<Post>>((ref) {
  return PostNotifier(ref);
});
