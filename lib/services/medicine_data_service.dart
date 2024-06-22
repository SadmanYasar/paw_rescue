import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/medicine_model.dart';
import 'package:http/http.dart' as http;

class MedicineService extends ChangeNotifier {
  List<Medicine> medicines = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> getMedicines() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http
          .get(Uri.parse('https://sadmanyasar.github.io/medicines.json'));

      if (response.statusCode == 200) {
        medicines = (json.decode(response.body) as List)
            .map((data) => Medicine.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load medicines');
      }

      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      print(e.toString());
      _isLoading = false;
    }
  }
}
