import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/adoption_model.dart';
import '../services/adoption_data_service.dart';
import '../widgets/app_state.dart';

/* 
==============================================
Accessed by all auth roles to view adoptions
==============================================
*/

class AdoptionPage extends StatefulWidget {
  const AdoptionPage({super.key}); // Fix the super constructor

  @override
  State<AdoptionPage> createState() => _AdoptionPageState();
}

class _AdoptionPageState extends State<AdoptionPage> {
  @override
  void initState() {
    super.initState();
    //if isRescuer show all reports
    if (Provider.of<ApplicationState>(context, listen: false).isRescuer) {
      _getAdoptions();
    } else {
      //if not rescuer show only user reports
      _getAdoptionsByUserId();
    }
  }

  Future<void> _getAdoptions() {
    return Provider.of<AdoptionService>(context, listen: false).getAdoptions();
  }

  Future<void> _getAdoptionsByUserId() {
    return Provider.of<AdoptionService>(context, listen: false)
        .getAdoptionsByUserId(userId: FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> _deleteAdoption(Adoption adoption) {
    return Provider.of<AdoptionService>(context, listen: false)
        .deleteAdoption(id: adoption.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adoptions'),
      ),
      body: Consumer<AdoptionService>(
        builder: (context, adoptionService, _) {
          if (adoptionService.isLoading) {
            // Show a loading circle
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (adoptionService.adoptions.isEmpty) {
              return const Center(
                child: Text('No adoptions found'),
              );
            } else {
              return ListView.builder(
                itemCount: adoptionService.adoptions.length,
                itemBuilder: (context, index) {
                  final adoption = adoptionService.adoptions[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                                'Adoption Application'), // Add the 'const' keyword
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Application: ${adoption.application}'),
                                Text('Phone Number: ${adoption.phone}'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                    'Close'), // Add the 'const' keyword
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(adoption.animalName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Username: ${adoption.userName}'),
                            Text('Status: ${adoption.status}'),
                          ],
                        ),
                        trailing: Provider.of<ApplicationState>(context,
                                    listen: false)
                                .isRescuer
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      //go to edit-adoption with the adoption object as extra
                                      context.pushNamed('edit-adoption',
                                          extra: adoption);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteAdoption(adoption);
                                    },
                                  ),
                                ],
                              )
                            : Container(),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
