class Event {
  final int id;
  final int profileId;
  final String title;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime createdAt;
  final String? creatorUsername;

  Event({
    required this.id,
    required this.profileId,
    required this.title,
    required this.description,
    required this.location,
    required this.startTime,
    required this.createdAt,
    this.creatorUsername,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'profile_id': profileId,
        'title': title,
        'description': description,
        'location': location,
        'start_time': startTime.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };

  factory Event.fromMap(Map<String, dynamic> map) => Event(
        id: map['id'],
        profileId: map['profile_id'],
        title: map['title'],
        description: map['description'],
        location: map['location'],
        startTime: DateTime.parse(map['start_time']),
        createdAt: DateTime.parse(map['created_at']),
        creatorUsername: map['profiles']?['username'],
      );
}
