import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/adoption_model.dart';

class AdoptionService extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  List<Adoption> adoptions = [];
  bool isLoading = false;
  int monthlyAdoptions = 0;

  // Create an adoption
  Future<void> createAdoption({Adoption? adoption}) async {
    try {
      final docRef = db.collection('adoptions').doc();
      Adoption newAdoption = Adoption(
        userName: adoption!.userName,
        animalName: adoption.animalName,
        status: adoption.status,
        phone: adoption.phone,
        application: adoption.application,
        time: adoption.time,
        id: docRef.id,
      );

      await docRef.set(newAdoption.toJson());
      adoptions.add(newAdoption);

      monthlyAdoptions = adoptions
          .where((element) => element.status == 'Approved')
          .where((element) =>
              element.time.isAfter(DateTime.now().subtract(Duration(days: 30))))
          .toList()
          .length;

      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Failed to create adoption: $e');
    }
  }

  // Read all adoptions
  Future<void> getAdoptions() async {
    try {
      isLoading = true;
      notifyListeners();
      final adoptionCollection = await db.collection('adoptions').get();
      adoptions = adoptionCollection.docs
          .map((doc) => Adoption.fromJson(doc.data()))
          .toList();

      monthlyAdoptions = adoptions
          .where((element) => element.status == 'Approved')
          .where((element) =>
              element.time.isAfter(DateTime.now().subtract(Duration(days: 30))))
          .toList()
          .length;

      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      isLoading = false;
      notifyListeners();
      print(e);
      throw Exception('Failed to read adoptions: $e');
    }
  }

  // Read adoptions by user ID
  Future<void> getAdoptionsByUserId({String? userName}) async {
    try {
      isLoading = true;
      notifyListeners();
      final adoptionCollection = await db
          .collection('adoptions')
          .where('userName', isEqualTo: userName)
          .get();
      adoptions = adoptionCollection.docs
          .map((doc) => Adoption.fromJson(doc.data()))
          .toList();

      monthlyAdoptions = adoptions
          .where((element) => element.status == 'Approved')
          .where((element) =>
              element.time.isAfter(DateTime.now().subtract(Duration(days: 30))))
          .toList()
          .length;

      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Failed to read adoptions: $e');
    }
  }

  // Update adoption
  Future<void> updateAdoption({Adoption? adoption}) async {
    try {
      await db
          .collection('adoptions')
          .doc(adoption!.id)
          .update(adoption.toJson());
      final index =
          adoptions.indexWhere((element) => element.id == adoption.id);
      adoptions[index] = adoption;

      monthlyAdoptions = adoptions
          .where((element) => element.status == 'Approved')
          .where((element) =>
              element.time.isAfter(DateTime.now().subtract(Duration(days: 30))))
          .toList()
          .length;

      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Failed to update adoption: $e');
    }
  }

  // Delete adoption
  Future<void> deleteAdoption({String? id}) async {
    try {
      await db.collection('adoptions').doc(id).delete();
      adoptions.removeWhere((element) => element.id == id);

      monthlyAdoptions = adoptions
          .where((element) => element.status == 'Approved')
          .where((element) =>
              element.time.isAfter(DateTime.now().subtract(Duration(days: 30))))
          .toList()
          .length;

      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Failed to delete adoption: $e');
    }
  }
}
