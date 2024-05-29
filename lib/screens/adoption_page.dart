import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/adoption_model.dart';
import '../services/adoption_data_service.dart';
import '../widgets/app_state.dart';
import '../widgets/widgets.dart';

class AdoptionPage extends StatefulWidget {
  const AdoptionPage({super.key});

  @override
  State<AdoptionPage> createState() => _AdoptionPageState();
}

class _AdoptionPageState extends State<AdoptionPage> {
  List<Adoption> adoptions = [];
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _animalIdController = TextEditingController();
  final _statusController = TextEditingController();
  final _applicationController = TextEditingController();
  final adoptionService = AdoptionService();

  @override
  void initState() {
    super.initState();
    // Fetch adoptions based on user's role
    if (Provider.of<ApplicationState>(context, listen: false).isRescuer) {
      _getAdoptions();
    } else {
      _getAdoptionsByUser();
    }
  }

  void _getAdoptions() async {
    try {
      final adoptions = await adoptionService.getAdoptions();
      if (mounted) {
        setState(() {
          this.adoptions = adoptions;
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void _getAdoptionsByUser() async {
    try {
      final adoptions = await adoptionService.getAdoptionsByUserId(
          userId: FirebaseAuth.instance.currentUser!.uid);
      if (mounted) {
        setState(() {
          this.adoptions = adoptions;
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void _addAdoption() async {
    if (_formKey.currentState!.validate()) {
      final adoption = Adoption(
        userId: _userIdController.text,
        animalId: _animalIdController.text,
        status: _statusController.text,
        application: _applicationController.text,
      );
      await adoptionService.createAdoption(adoption: adoption);
      if (mounted) {
        _getAdoptions();
      }
    }
  }

  void _updateAdoption(Adoption adoption) async {
    if (_formKey.currentState!.validate()) {
      final updatedAdoption = Adoption(
        userId: adoption.userId,
        animalId: _animalIdController.text,
        status: _statusController.text,
        application: _applicationController.text,
      );
      await adoptionService.updateAdoption(adoption: updatedAdoption);
      _getAdoptions();
    }
  }

  void _deleteAdoption(String userId) async {
    await adoptionService.deleteAdoption(userId: userId);
    _getAdoptions();
  }

  void _showForm({Adoption? adoption}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(adoption == null ? 'Add Adoption' : 'Edit Adoption'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _userIdController..text = adoption?.userId ?? '',
                  decoration: InputDecoration(labelText: 'User ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a User ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _animalIdController
                    ..text = adoption?.animalId ?? '',
                  decoration: InputDecoration(labelText: 'Animal ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an Animal ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _statusController..text = adoption?.status ?? '',
                  decoration: InputDecoration(labelText: 'Status'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Status';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _applicationController
                    ..text = adoption?.application ?? '',
                  decoration: InputDecoration(labelText: 'Application'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an Application';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            StyledButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            StyledButton(
              child: Text(adoption == null ? 'Add' : 'Update'),
              onPressed: () {
                if (adoption == null) {
                  _addAdoption();
                } else {
                  _updateAdoption(adoption);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adoptions'),
      ),
      body: ListView.builder(
        itemCount: adoptions.length,
        itemBuilder: (context, index) {
          final adoption = adoptions[index];
          return Card(
            child: ListTile(
              leading: Image.asset('assets/logo.png'),
              title: Text(adoption.userId),
              subtitle: Text(adoption.animalId),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Adoption Details'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('User ID: ${adoption.userId}'),
                          Text('Animal ID: ${adoption.animalId}'),
                          Text('Status: ${adoption.status}'),
                          Text('Application: ${adoption.application}'),
                        ],
                      ),
                      actions: [
                        StyledButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showForm(adoption: adoption);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteAdoption(adoption.userId);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
