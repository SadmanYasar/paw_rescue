class Adoption {
  final String userId;
  final String animalId;
  final String status;
  final String application;

  Adoption(
      {required this.userId,
      required this.animalId,
      required this.status,
      required this.application});

  factory Adoption.fromJson(Map<String, dynamic> json) {
    return Adoption(
        userId: json['userId'] ?? '',
        animalId: json['animalId'] ?? '',
        status: json['status'] ?? '',
        application: json['application'] ?? '');
  }

  toJson() {
    return {
      'userId': userId,
      'animalId': animalId,
      'status': status,
      'application': application,
    };
  }
}
