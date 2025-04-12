import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/database.dart';
import '../models/comment.dart';

class CommentNotifier extends StateNotifier<Map<int, List<Comment>>> {
  final DatabaseHelper _dbHelper;
  final _supabase = Supabase.instance.client;

  CommentNotifier(this._dbHelper) : super({}) {
    loadComments();
  }

  Future<void> loadComments() async {
    final maps = await _dbHelper.getComments();
    final grouped = <int, List<Comment>>{};
    for (var map in maps) {
      final comment = Comment.fromMap(map);
      grouped[comment.postId] = [...(grouped[comment.postId] ?? []), comment];
    }
    state = grouped;

    final remoteComments = await _supabase.from('comments').select();
    final remoteGrouped = <int, List<Comment>>{};
    for (var map in remoteComments) {
      final comment = Comment.fromMap(map);
      remoteGrouped[comment.postId] = [...(remoteGrouped[comment.postId] ?? []), comment];
    }
    state = remoteGrouped;
  }

  Future<void> addComment(Comment comment) async {
    final newCommentMap = await _dbHelper.createComment(comment.toMap());
    final newComment = Comment.fromMap(newCommentMap);
    state = {
      ...state,
      comment.postId: [...(state[comment.postId] ?? []), newComment],
    };
    await _supabase.from('comments').insert(newComment.toMap());
  }
}

final commentProvider = StateNotifierProvider<CommentNotifier, Map<int, List<Comment>>>((ref) {
  return CommentNotifier(DatabaseHelper());
});
