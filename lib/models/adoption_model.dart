class Adoption {
  final String userName;
  final String animalName;
  final String status;
  final String application;
  final String phone;
  final String? id;

  Adoption({
    required this.userName,
    required this.animalName,
    required this.status,
    required this.application,
    required this.phone,
    this.id,
  });

  factory Adoption.fromJson(Map<String, dynamic> json) {
    return Adoption(
        userName: json['userName'] ?? '',
        animalName: json['animalName'] ?? '',
        status: json['status'] ?? '',
        application: json['application'] ?? '',
        phone: json['phone'] ?? '',
        id: json['id']);
  }

  toJson() {
    return {
      'userName': userName,
      'animalName': animalName,
      'status': status,
      'application': application,
      'phone': phone,
      'id': id
    };
  }
}
