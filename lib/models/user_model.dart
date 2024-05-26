import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String role;

  UserModel({required this.email, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      role: json['role'] ?? {},
    );
  }

  toJson() {
    return {
      'email': email,
      'role': role,
    };
  }
}
