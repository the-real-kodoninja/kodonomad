import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../models/comment.dart';

class CommentNotifier extends StateNotifier<Map<int, List<Comment>>> {
  final DatabaseHelper _dbHelper;

  CommentNotifier(this._dbHelper) : super({});

  Future<void> loadComments(int postId) async {
    final comments = await _dbHelper.getComments(postId);
    state = {...state, postId: comments};
  }

  Future<void> addComment(Comment comment) async {
    final newComment = await _dbHelper.createComment(comment);
    state = {
      ...state,
      comment.postId: [...(state[comment.postId] ?? []), newComment],
    };
  }
}

final commentProvider = StateNotifierProvider<CommentNotifier, Map<int, List<Comment>>>((ref) {
  return CommentNotifier(DatabaseHelper.instance);
});
