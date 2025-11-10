class ServiceModel {
  final String id;
  final String name;
  final String category;
  final String image;
  final double rating;
  final String phone;
  final String city;

  ServiceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.rating,
    required this.phone,
    required this.city,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      image: map['image'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      phone: map['phone'] ?? '',
      city: map['city'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'image': image,
        'rating': rating,
        'phone': phone,
        'city': city,
      };
}
