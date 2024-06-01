import 'package:flutter/material.dart';
import 'package:paw_rescue/models/adoption_model.dart';
import 'package:paw_rescue/services/adoption_data_service.dart';
import 'package:provider/provider.dart';

class EditAdoptionScreen extends StatefulWidget {
  final Adoption adoption;

  const EditAdoptionScreen({super.key, required this.adoption});

  @override
  State<EditAdoptionScreen> createState() => _EditAdoptionScreenState();
}

class _EditAdoptionScreenState extends State<EditAdoptionScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _animalnameController;
  late TextEditingController _phoneController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.adoption.userName);
    _animalnameController =
        TextEditingController(text: widget.adoption.animalName);
    _phoneController = TextEditingController(text: widget.adoption.phone);
    _statusController = TextEditingController(text: widget.adoption.status);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _animalnameController.dispose();
    _phoneController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Adoption Application'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: _animalnameController,
              decoration: const InputDecoration(labelText: 'Animal Name'),
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextFormField(
              controller: _statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<AdoptionService>(context, listen: false)
                    .updateAdoption(
                  adoption: Adoption(
                    id: widget.adoption.id,
                    userName: _usernameController.text,
                    animalName: _animalnameController.text,
                    phone: _phoneController.text,
                    status: _statusController.text,
                    application: widget.adoption.application,
                  ),
                );
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
