import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/database.dart';
import '../models/forum_post.dart';

class ForumNotifier extends StateNotifier<List<ForumPost>> {
  final DatabaseHelper _dbHelper;
  final _supabase = Supabase.instance.client;

  ForumNotifier(this._dbHelper) : super([]) {
    loadPosts();
  }

  Future<void> loadPosts() async {
    final maps = await _dbHelper.getForumPosts();
    state = maps.map((map) => ForumPost.fromMap(map)).toList();
    final remotePosts = await _supabase.from('forum_posts').select();
    state = remotePosts.map((map) => ForumPost.fromMap(map)).toList();
  }

  Future<void> addPost(ForumPost post) async {
    final newPostMap = await _dbHelper.createForumPost(post.toMap());
    final newPost = ForumPost.fromMap(newPostMap);
    state = [...state, newPost];
    await _supabase.from('forum_posts').insert(newPost.toMap());
  }
  
  Future<List<Map<String, dynamic>>> getReplies(int postId) async {
    return await _supabase.from('forum_replies').select().eq('forum_post_id', postId);
  }

  Future<void> addReply(int postId, int profileId, String content) async {
    final reply = {'forum_post_id': postId, 'profile_id': profileId, 'content': content};
    await _supabase.from('forum_replies').insert(reply);
  }

  Future<void> upvotePost(int postId, int profileId) async {
    await _dbHelper.upvoteForumPost(postId, profileId);
    await _supabase.from('forum_posts').update({'upvotes': state.firstWhere((p) => p.id == postId).upvotes + 1}).eq('id', postId);
    state = [for (final p in state) p.id == postId ? p.copyWith(upvotes: p.upvotes + 1) : p];
  }

  Future<void> downvotePost(int postId, int profileId) async {
    await _dbHelper.downvoteForumPost(postId, profileId);
    await _supabase.from('forum_posts').update({'downvotes': state.firstWhere((p) => p.id == postId).downvotes + 1}).eq('id', postId);
    state = [for (final p in state) p.id == postId ? p.copyWith(downvotes: p.downvotes + 1) : p];
  }
}

Future<List<Map<String, dynamic>>> getReplies(int postId) async {
    return await supabase.from('forum_replies').select().eq('forum_post_id', postId);
  }

  Future<void> addReply(int postId, int profileId, String content) async {
    await supabase.from('forum_replies').insert({
      'forum_post_id': postId,
      'profile_id': profileId,
      'content': content,
    });
  }

final forumProvider = StateNotifierProvider<ForumNotifier, List<ForumPost>>((ref) => ForumNotifier(DatabaseHelper()));
