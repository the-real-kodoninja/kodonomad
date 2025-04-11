import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../models/reply.dart';

class ReplyNotifier extends StateNotifier<Map<int, List<Reply>>> {
  final DatabaseHelper _dbHelper;

  ReplyNotifier(this._dbHelper) : super({});

  Future<void> loadReplies(int commentId) async {
    final replies = await _dbHelper.getReplies(commentId);
    state = {...state, commentId: replies};
  }

  Future<void> addReply(Reply reply) async {
    final newReply = await _dbHelper.createReply(reply);
    state = {
      ...state,
      reply.commentId: [...(state[reply.commentId] ?? []), newReply],
    };
  }
}

final replyProvider = StateNotifierProvider<ReplyNotifier, Map<int, List<Reply>>>((ref) {
  return ReplyNotifier(DatabaseHelper.instance);
});
