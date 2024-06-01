import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paw_rescue/models/adoption_model.dart';
import 'package:paw_rescue/models/animal_model.dart';
import 'package:paw_rescue/services/adoption_data_service.dart';
import 'package:provider/provider.dart';

/* 
==========================================
Accessed by reporter to apply for adoption
==========================================
*/

class ApplicationScreen extends StatefulWidget {
  final Animal animal;
  const ApplicationScreen({super.key, required this.animal});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _submitApplication() async {
    await Provider.of<AdoptionService>(context, listen: false).createAdoption(
      adoption: Adoption(
        userName: FirebaseAuth.instance.currentUser!.displayName!,
        animalName: widget.animal.name,
        status: 'Pending',
        phone: _phoneController.text,
        application: _reasonController.text,
      ),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Adoption Application'),
        ),
        body: SingleChildScrollView(
          //create a form with two textforminputs and validators and a submit button
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Application for ${widget.animal.name}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason for Adoption',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a reason for adoption';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_phoneController.text.isNotEmpty &&
                        _reasonController.text.isNotEmpty) {
                      _submitApplication().then((_) {
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  child: const Text('Submit Application'),
                ),
              ],
            ),
          ),
        ));
  }
}
