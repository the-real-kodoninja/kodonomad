import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reply_provider.dart';
import '../models/reply.dart';

class ReplyScreen extends ConsumerStatefulWidget {
  final int commentId;

  const ReplyScreen({required this.commentId});

  @override
  _ReplyScreenState createState() => _ReplyScreenState();
}

class _ReplyScreenState extends ConsumerState<ReplyScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(replyProvider.notifier).loadReplies(widget.commentId);
  }

  @override
  Widget build(BuildContext context) {
    final replies = ref.watch(replyProvider)[widget.commentId] ?? [];
    final myId = 1;

    return Scaffold(
      appBar: AppBar(title: Text('Replies')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: replies.length,
              itemBuilder: (context, index) {
                final reply = replies[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: CachedNetworkImageProvider('https://via.placeholder.com/150'),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NomadUser', style: Theme.of(context).textTheme.bodySmall),
                          Text(reply.content),
                        ],
                      ),
                    ],
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
                    decoration: InputDecoration(hintText: 'Add a reply...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      ref.read(replyProvider.notifier).addReply(
                            Reply(
                              id: 0,
                              commentId: widget.commentId,
                              profileId: myId,
                              content: _controller.text,
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
