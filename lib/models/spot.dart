class Spot {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String type;
  final double rating;

  Spot({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.rating = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
      'rating': rating,
    };
  }

  factory Spot.fromMap(Map<String, dynamic> map) {
    return Spot(
      id: map['id'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      type: map['type'],
      rating: map['rating'],
    );
  }

  Spot copyWith({
    int? id,
    String? name,
    double? latitude,
    double? longitude,
    String? type,
    double? rating,
  }) {
    return Spot(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
      rating: rating ?? this.rating,
    );
  }
}
