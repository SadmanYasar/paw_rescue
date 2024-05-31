import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/adoption_model.dart';

class AdoptionService extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  List<Adoption> reports = [];
  bool isLoading = false;

  // Create an adoption
  Future<Adoption> createAdoption({Adoption? adoption}) async {
    try {
      final docRef = db.collection('adoptions').doc();
      Adoption newAdoption = Adoption(
          userId: adoption!.userId,
          animalId: adoption.animalId,
          status: adoption.status,
          application: adoption.application);

      await docRef.set(newAdoption.toJson());
      return newAdoption;
    } on Exception catch (e) {
      throw Exception('Failed to create adoption: $e');
    }
  }

  // Read all adoptions
  Future<List<Adoption>> getAdoptions() async {
    try {
      final adoptionCollection = await db.collection('adoptions').get();
      print(adoptionCollection.docs);
      return adoptionCollection.docs
          .map((doc) => Adoption.fromJson(doc.data()))
          .toList();
    } on Exception catch (e) {
      print(e);
      throw Exception('Failed to read adoptions: $e');
    }
  }

  // Read adoptions by user ID
  Future<List<Adoption>> getAdoptionsByUserId({String? userId}) async {
    try {
      final adoptionCollection = await db
          .collection('adoptions')
          .where('userId', isEqualTo: userId)
          .get();
      return adoptionCollection.docs
          .map((doc) => Adoption.fromJson(doc.data()))
          .toList();
    } on Exception catch (e) {
      throw Exception('Failed to read adoptions: $e');
    }
  }

  // Update adoption
  Future<Adoption> updateAdoption({Adoption? adoption}) async {
    try {
      await db
          .collection('adoptions')
          .doc(adoption!.userId)
          .update(adoption.toJson());
      return adoption;
    } on Exception catch (e) {
      throw Exception('Failed to update adoption: $e');
    }
  }

  // Delete adoption
  Future deleteAdoption({String? userId}) async {
    try {
      await db.collection('adoptions').doc(userId).delete();
    } on Exception catch (e) {
      throw Exception('Failed to delete adoption: $e');
    }
  }
}
