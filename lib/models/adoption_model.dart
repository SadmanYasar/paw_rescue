class Adoption {
  final String userId;
  final String animalId;
  final String status;
  final String application;
  final String? id;

  Adoption({
    required this.userId,
    required this.animalId,
    required this.status,
    required this.application,
    this.id,
  });

  factory Adoption.fromJson(Map<String, dynamic> json) {
    return Adoption(
        userId: json['userId'] ?? '',
        animalId: json['animalId'] ?? '',
        status: json['status'] ?? '',
        application: json['application'] ?? '',
        id: json['id']);
  }

  toJson() {
    return {
      'userId': userId,
      'animalId': animalId,
      'status': status,
      'application': application,
      'id': id
    };
  }
}
