import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String name;
  final String description;
  final DateTime time;
  final String address;
  final String userId;
  final String phone;
  final String rescued;
  final String? id;

  Report(
      {required this.name,
      required this.description,
      required this.time,
      required this.address,
      required this.userId,
      required this.phone,
      required this.rescued,
      required this.id});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        time: (json['time']).toDate() ?? DateTime.now(),
        address: json['address'] ?? '',
        userId: json['userId'] ?? '',
        phone: json['phone'] ?? '',
        rescued: json['rescued'] ?? 'false',
        id: json['id']);
  }

  toJson() {
    return {
      'name': name,
      'description': description,
      'time': Timestamp.fromDate(time),
      'address': address,
      'userId': userId,
      'phone': phone,
      'rescued': rescued,
      'id': id
    };
  }
}
