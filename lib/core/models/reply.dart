class Reply {
  final int id;
  final int commentId;
  final int profileId;
  final String content;
  final DateTime timestamp;

  Reply({
    required this.id,
    required this.commentId,
    required this.profileId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'commentId': commentId,
      'profileId': profileId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Reply.fromMap(Map<String, dynamic> map) {
    return Reply(
      id: map['id'],
      commentId: map['commentId'],
      profileId: map['profileId'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Reply copyWith({
    int? id,
    int? commentId,
    int? profileId,
    String? content,
    DateTime? timestamp,
  }) {
    return Reply(
      id: id ?? this.id,
      commentId: commentId ?? this.commentId,
      profileId: profileId ?? this.profileId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
