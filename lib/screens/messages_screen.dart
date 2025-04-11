import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../providers/message_provider.dart';
import '../models/message.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  final int receiverId;

  const MessagesScreen({required this.receiverId});

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  final _controller = TextEditingController();
  final myId = 1;
  final key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(16);
  late final encrypter = encrypt.Encrypter(encrypt.AES(key));

  @override
  void initState() {
    super.initState();
    ref.read(messageProvider.notifier).loadMessages(myId, widget.receiverId);
  }
  
  String _encryptMessage(String text) {
    return encrypter.encrypt(text, iv: iv).base64;
  }

  String _decryptMessage(String encrypted) {
    return encrypter.decrypt64(encrypted, iv: iv);
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messageProvider).state['$myId-${widget.receiverId}'] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('Chat with NomadUser')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message.senderId == myId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _decryptMessage(message.content),
                      style: TextStyle(color: isMe ? Colors.white : null),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      ref.read(messageProvider.notifier).sendMessage(
                            Message(
                              id: 0,
                              senderId: myId,
                              receiverId: widget.receiverId,
                              content: _encryptMessage(_controller.text),
                              timestamp: DateTime.now(),
                            ),
                          );
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Add to HomeScreen bottom nav
// Update _titles: ['Feed', 'Map', 'Market', 'Forums', 'Messages', 'Profile']
// Add BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages')
// Case 4: return MessagesScreen(receiverId: 2); // Placeholder receiver
