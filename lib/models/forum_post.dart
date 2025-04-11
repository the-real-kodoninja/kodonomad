class ForumPost {
  final int id;
  final int profileId;
  final String title;
  final String content;
  final DateTime timestamp;
  final int upvotes;
  final int downvotes;

  ForumPost({
    required this.id,
    required this.profileId,
    required this.title,
    required this.content,
    required this.timestamp,
    this.upvotes = 0,
    this.downvotes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileId': profileId,
      'title': title,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
  }

  factory ForumPost.fromMap(Map<String, dynamic> map) {
    return ForumPost(
      id: map['id'],
      profileId: map['profileId'],
      title: map['title'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
      upvotes: map['upvotes'],
      downvotes: map['downvotes'],
    );
  }

  ForumPost copyWith({
    int? id,
    int? profileId,
    String? title,
    String? content,
    DateTime? timestamp,
    int? upvotes,
    int? downvotes,
  }) {
    return ForumPost(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
    );
  }
}
