import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../models/message.dart';

class MessageNotifier extends StateNotifier<Map<String, List<Message>>> {
  final DatabaseHelper _dbHelper;

  MessageNotifier(this._dbHelper) : super({});

  Future<void> loadMessages(int senderId, int receiverId) async {
    final key = '$senderId-$receiverId';
    final messages = await _dbHelper.getMessages(senderId, receiverId);
    state = {...state, key: messages};
  }

  Future<void> sendMessage(Message message) async {
    final newMessage = await _dbHelper.sendMessage(message);
    final key = '${message.senderId}-${message.receiverId}';
    state = {
      ...state,
      key: [...(state[key] ?? []), newMessage],
    };
  }

  Future<void> markRead(int messageId) async {
    await _dbHelper.markMessageRead(messageId);
    state = {
      for (final entry in state.entries)
        entry.key: [
          for (final msg in entry.value)
            msg.id == messageId ? msg.copyWith(isRead: true) : msg,
        ],
    };
  }
}

final messageProvider = StateNotifierProvider<MessageNotifier, Map<String, List<Message>>>((ref) {
  return MessageNotifier(DatabaseHelper.instance);
});
