class Animal {
  final String name;
  final String age;
  final String breed;
  final String imageURL;

  Animal(
      {required this.name,
      required this.age,
      required this.breed,
      required this.imageURL});

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
        name: json['name'] ?? '',
        age: json['age'] ?? '',
        breed: json['breed'] ?? '',
        imageURL: json['imageURL'] ?? '');
  }

  toJson() {
    return {
      'name': name,
      'age': age,
      'breed': breed,
      'imageURL': imageURL,
    };
  }
}
