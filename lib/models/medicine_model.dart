class Medicine {
  final String name;
  final double price;
  final String description;
  final String imageURL;
  final String productLink;

  Medicine(
      {required this.name,
      required this.price,
      required this.description,
      required this.imageURL,
      required this.productLink});

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'] ?? '',
      price: json['price'] ?? 0.0,
      description: json['description'] ?? '',
      imageURL: json['imageURL'] ?? '',
      productLink: json['productLink'] ?? '',
    );
  }

  toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imageURL': imageURL,
      'productLink': productLink
    };
  }
}
