class Post {
  final int id;
  final int profileId;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  final int likes;

  Post({
    required this.id,
    required this.profileId,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    this.likes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileId': profileId,
      'content': content,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      profileId: map['profileId'],
      content: map['content'],
      imageUrl: map['imageUrl'],
      timestamp: DateTime.parse(map['timestamp']),
      likes: map['likes'],
    );
  }
}
