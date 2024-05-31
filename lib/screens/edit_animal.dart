//edit_report.dart
import 'package:flutter/material.dart';
import 'package:paw_rescue/models/animal_model.dart';
import 'package:paw_rescue/services/animal_data_service.dart';
import 'package:provider/provider.dart';

class EditAnimalScreen extends StatefulWidget {
  final Animal? animal;

  const EditAnimalScreen({super.key, this.animal});

  @override
  State<EditAnimalScreen> createState() => _EditAnimalScreenState();
}

class _EditAnimalScreenState extends State<EditAnimalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _breedController = TextEditingController();
  //image upload controller
  final _imageURLController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.animal != null) {
      _nameController.text = widget.animal!.name;
      _ageController.text = widget.animal!.age;
      _breedController.text = widget.animal!.breed;
      _imageURLController.text = widget.animal!.imageURL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.animal == null ? 'Create Animal' : 'Edit Animal'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nameController.text = value!;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an age';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _ageController.text = value!;
                  },
                ),
                TextFormField(
                  controller: _breedController,
                  decoration: const InputDecoration(
                    labelText: 'Breed',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a breed';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _breedController.text = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ButtonStyle(
                    //make it full width
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 50),
                    ),
                    //add padding to the button
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(16.0),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final animal = Animal(
                        name: _nameController.text,
                        age: _ageController.text,
                        breed: _breedController.text,
                        imageURL: _imageURLController.text,
                        id: widget.animal?.id,
                      );
                      if (widget.animal == null) {
                        Provider.of<AnimalService>(context, listen: false)
                            .createAnimal(animal: animal)
                            .then((value) => Navigator.pop(context));
                      } else {
                        Provider.of<AnimalService>(context, listen: false)
                            .updateAnimal(animal: animal)
                            .then((value) => Navigator.pop(context));
                      }
                    }
                  },
                  child: Text(widget.animal == null ? 'Create' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
