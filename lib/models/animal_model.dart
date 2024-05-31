class Animal {
  final String name;
  final String age;
  final String breed;
  final String imageURL;
  final String? id;

  Animal({
    required this.name,
    required this.age,
    required this.breed,
    required this.imageURL,
    required this.id,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      name: json['name'] ?? '',
      age: json['age'] ?? '',
      breed: json['breed'] ?? '',
      imageURL: json['imageURL'] ?? '',
      id: json['id'],
    );
  }

  toJson() {
    return {
      'name': name,
      'age': age,
      'breed': breed,
      'imageURL': imageURL,
      'id': id,
    };
  }
}
