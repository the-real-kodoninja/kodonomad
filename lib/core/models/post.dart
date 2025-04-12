class Post {
  final int id;
  final int profileId;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  final int likes;
  final int? shares;

  Post({
    required this.id,
    required this.profileId,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    required this.likes,
    this.shares,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'profileId': profileId,
        'content': content,
        'imageUrl': imageUrl,
        'timestamp': timestamp.toIso8601String(),
        'likes': likes,
        'shares': shares,
      };

  factory Post.fromMap(Map<String, dynamic> map) => Post(
        id: map['id'],
        profileId: map['profileId'],
        content: map['content'],
        imageUrl: map['imageUrl'],
        timestamp: DateTime.parse(map['timestamp']),
        likes: map['likes'],
        shares: map['shares'],
      );

  Post copyWith({
    int? id,
    int? profileId,
    String? content,
    String? imageUrl,
    DateTime? timestamp,
    int? likes,
    int? shares,
  }) => Post(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        content: content ?? this.content,
        imageUrl: imageUrl ?? this.imageUrl,
        timestamp: timestamp ?? this.timestamp,
        likes: likes ?? this.likes,
        shares: shares ?? this.shares,
      );
}
