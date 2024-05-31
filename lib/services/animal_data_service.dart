import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/animal_model.dart';

class AnimalService extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  List<Animal> animals = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Create an animal
  Future<void> createAnimal({Animal? animal}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final docRef = db.collection('animals').doc();
      Animal newAnimal = Animal(
        age: animal!.age,
        breed: animal.breed,
        imageURL: animal.imageURL,
        name: animal.name,
        id: docRef.id,
      );

      await docRef.set(newAnimal.toJson());
      animals.add(newAnimal);

      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e.toString());
      throw Exception('Failed to create animal: $e');
    }
  }

  // Read all animals
  Future<void> getAnimals() async {
    try {
      _isLoading = true;
      notifyListeners();

      final animalCollection = await db.collection('animals').get();
      animals = animalCollection.docs
          .map((doc) => Animal.fromJson(doc.data()))
          .toList();

      print(animals[0].imageURL); // Debugging purposes
      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e);
      throw Exception('Failed to read animals: $e');
    }
  }

  // Update animal
  Future<void> updateAnimal({Animal? animal}) async {
    try {
      _isLoading = true;
      notifyListeners();

      await db.collection('animals').doc(animal!.id).update(animal.toJson());
      final index = animals.indexWhere((element) => element.id == animal.id);
      animals[index] = animal;

      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e.toString());
      throw Exception('Failed to update animal: $e');
    }
  }

  // Delete animal
  Future deleteAnimal({String? id}) async {
    try {
      _isLoading = true;
      notifyListeners();

      await db.collection('animals').doc(id).delete();
      animals.removeWhere((element) => element.id == id);

      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e.toString());
      throw Exception('Failed to delete animal: $e');
    }
  }
}
