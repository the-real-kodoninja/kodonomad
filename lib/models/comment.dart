class Comment {
  final int id;
  final int postId;
  final int profileId;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.postId,
    required this.profileId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'profileId': profileId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      postId: map['postId'],
      profileId: map['profileId'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Comment copyWith({
    int? id,
    int? postId,
    int? profileId,
    String? content,
    DateTime? timestamp,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      profileId: profileId ?? this.profileId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
