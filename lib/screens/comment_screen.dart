import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/comment_provider.dart';
import '../providers/reply_provider.dart';
import '../models/comment.dart';
import 'reply_screen.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final int postId;

  const CommentScreen({required this.postId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(commentProvider.notifier).loadComments(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentProvider)[widget.postId] ?? [];
    final myId = 1;

    return Scaffold(
      appBar: AppBar(title: Text('Comments')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return CommentTile(comment: comment);
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
                    decoration: InputDecoration(hintText: 'Add a comment...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      ref.read(commentProvider.notifier).addComment(
                            Comment(
                              id: 0,
                              postId: widget.postId,
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

class CommentTile extends ConsumerWidget {
  final Comment comment;

  const CommentTile({required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final replies = ref.watch(replyProvider)[comment.id] ?? [];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider('https://via.placeholder.com/150'),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NomadUser', style: Theme.of(context).textTheme.titleMedium),
                  Text(comment.content),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 48),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ReplyScreen(commentId: comment.id)),
                    );
                  },
                  child: Text('${replies.length} Replies'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
