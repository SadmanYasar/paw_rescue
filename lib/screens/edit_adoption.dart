import 'package:flutter/material.dart';
import 'package:paw_rescue/models/adoption_model.dart';
import 'package:paw_rescue/models/animal_model.dart';

/* 
==========================================
Accessed by rescuer to approve adoption
==========================================
*/

class EditAdoptionScreen extends StatefulWidget {
  final Adoption adoption;

  const EditAdoptionScreen({super.key, required this.adoption});

  @override
  State<EditAdoptionScreen> createState() => _EditAdoptionScreenState();
}

class _EditAdoptionScreenState extends State<EditAdoptionScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
