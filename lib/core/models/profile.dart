class Profile {
  final int id;
  final String username;
  final String bio;
  final String nomadType;
  final String photoUrl;
  final int milesTraveled;

  Profile({
    required this.id,
    required this.username,
    required this.bio,
    required this.nomadType,
    required this.photoUrl,
    this.milesTraveled = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'bio': bio,
      'nomadType': nomadType,
      'photoUrl': photoUrl,
      'milesTraveled': milesTraveled,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      username: map['username'],
      bio: map['bio'],
      nomadType: map['nomadType'],
      photoUrl: map['photoUrl'],
      milesTraveled: map['milesTraveled'],
    );
  }

  Profile copyWith({
    int? id,
    String? username,
    String? bio,
    String? nomadType,
    String? photoUrl,
    int? milesTraveled,
  }) {
    return Profile(
      id: id ?? this.id,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      nomadType: nomadType ?? this.nomadType,
      photoUrl: photoUrl ?? this.photoUrl,
      milesTraveled: milesTraveled ?? this.milesTraveled,
    );
  }
}
