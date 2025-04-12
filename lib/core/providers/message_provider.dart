import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/database.dart';
import '../models/message.dart';

class MessageNotifier extends StateNotifier<Map<String, List<Message>>> {
  final DatabaseHelper _dbHelper;
  final _supabase = Supabase.instance.client;

  MessageNotifier(this._dbHelper) : super({}) {
    loadMessages();
  }

  Future<void> loadMessages() async {
    final maps = await _dbHelper.getMessages();
    final grouped = <String, List<Message>>{};
    for (var map in maps) {
      final message = Message.fromMap(map);
      final key = '${message.senderId}-${message.receiverId}';
      grouped[key] = [...(grouped[key] ?? []), message];
    }
    state = grouped;

    final remoteMessages = await _supabase.from('messages').select();
    final remoteGrouped = <String, List<Message>>{};
    for (var map in remoteMessages) {
      final message = Message.fromMap(map);
      final key = '${message.senderId}-${message.receiverId}';
      remoteGrouped[key] = [...(remoteGrouped[key] ?? []), message];
    }
    state = remoteGrouped;
  }

  Future<void> sendMessage(Message message) async {
    final newMessageMap = await _dbHelper.sendMessage(message.toMap());
    final newMessage = Message.fromMap(newMessageMap);
    final key = '${message.senderId}-${message.receiverId}';
    state = {
      ...state,
      key: [...(state[key] ?? []), newMessage],
    };
    await _supabase.from('messages').insert(newMessage.toMap());
  }
}

final messageProvider = StateNotifierProvider<MessageNotifier, Map<String, List<Message>>>((ref) {
  return MessageNotifier(DatabaseHelper());
});
