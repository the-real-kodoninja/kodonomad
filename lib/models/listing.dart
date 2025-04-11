class Listing {
  final int id;
  final int profileId;
  final String title;
  final String description;
  final double price;
  final String? imageUrl;

  Listing({
    required this.id,
    required this.profileId,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileId': profileId,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory Listing.fromMap(Map<String, dynamic> map) {
    return Listing(
      id: map['id'],
      profileId: map['profileId'],
      title: map['title'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['imageUrl'],
    );
  }

  Listing copyWith({
    int? id,
    int? profileId,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
  }) {
    return Listing(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
