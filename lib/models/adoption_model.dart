import 'package:cloud_firestore/cloud_firestore.dart';

class Adoption {
  final String userName;
  final String animalName;
  final String status;
  final String application;
  final String phone;
  final DateTime time;
  final String? id;

  Adoption({
    required this.userName,
    required this.animalName,
    required this.status,
    required this.application,
    required this.phone,
    required this.time,
    this.id,
  });

  factory Adoption.fromJson(Map<String, dynamic> json) {
    return Adoption(
        userName: json['userName'] ?? '',
        animalName: json['animalName'] ?? '',
        status: json['status'] ?? '',
        application: json['application'] ?? '',
        phone: json['phone'] ?? '',
        time: (json['time']).toDate() ?? DateTime.now(),
        id: json['id']);
  }

  toJson() {
    return {
      'userName': userName,
      'animalName': animalName,
      'status': status,
      'application': application,
      'phone': phone,
      'time': Timestamp.fromDate(time),
      'id': id
    };
  }
}
