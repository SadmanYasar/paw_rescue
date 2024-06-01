import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/adoption_model.dart';

class AdoptionService extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  List<Adoption> adoptions = [];
  bool isLoading = false;

  // Create an adoption
  Future<void> createAdoption({Adoption? adoption}) async {
    try {
      final docRef = db.collection('adoptions').doc();
      Adoption newAdoption = Adoption(
          userName: adoption!.userName,
          animalName: adoption.animalName,
          status: adoption.status,
          phone: adoption.phone,
          application: adoption.application);

      await docRef.set(newAdoption.toJson());
      adoptions.add(newAdoption);

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
      final adoptionCollection = await db.collection('adoptions').get();
      adoptions = adoptionCollection.docs
          .map((doc) => Adoption.fromJson(doc.data()))
          .toList();

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
  Future<void> getAdoptionsByUserId({String? userId}) async {
    try {
      final adoptionCollection = await db
          .collection('adoptions')
          .where('userId', isEqualTo: userId)
          .get();
      adoptions = adoptionCollection.docs
          .map((doc) => Adoption.fromJson(doc.data()))
          .toList();

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

      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      isLoading = false;
      notifyListeners();
      throw Exception('Failed to delete adoption: $e');
    }
  }
}
