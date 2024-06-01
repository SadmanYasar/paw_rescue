//edit_report.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:paw_rescue/models/animal_model.dart';
import 'package:paw_rescue/services/animal_data_service.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

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
  String imageURL = '';
  String uploadState = '';

  @override
  void initState() {
    super.initState();
    if (widget.animal != null) {
      _nameController.text = widget.animal!.name;
      _ageController.text = widget.animal!.age;
      _breedController.text = widget.animal!.breed;
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
                IconButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 25
                      );
                      print('${file?.path}');

                      if (file == null) return;

                      setState(() {
                        uploadState = 'Uploading image...';
                      });

                      String uniqueFileName =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      //Get a reference to storage root
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('images');

                      //Create a reference for the image to be stored
                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);

                      //Handle errors/success
                      try {
                        //Store the file
                        await referenceImageToUpload.putFile(File(file.path));
                        //Success: get the download URL
                        imageURL =
                            await referenceImageToUpload.getDownloadURL();

                        setState(() {
                          uploadState = 'Image uploaded successfully';
                        });
                      } catch (error) {
                        //Some error occurred
                        setState(() {
                          uploadState = 'Failed to upload image';
                        });
                        print('Error uploading image: $error');
                      }
                    },
                    icon: const Icon(Icons.camera_alt)),
                if (uploadState.isNotEmpty) Text(uploadState),
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
                    if (imageURL.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please upload an image')));

                      return;
                    }

                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final animal = Animal(
                        name: _nameController.text,
                        age: _ageController.text,
                        breed: _breedController.text,
                        imageURL: imageURL,
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
