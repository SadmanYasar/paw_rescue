import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:paw_rescue/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/adoption_model.dart';
import '../services/adoption_data_service.dart';
import '../widgets/app_state.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    Future.microtask(() {
      if (Provider.of<ApplicationState>(context, listen: false).isRescuer) {
        _getAdoptions();
      } else {
        //if not rescuer show only user reports
        _getAdoptionsByUserId();
      }
    });
  }

  Future<void> _getAdoptions() {
    return Provider.of<AdoptionService>(context, listen: false).getAdoptions();
  }

  Future<void> _getAdoptionsByUserId() {
    return Provider.of<AdoptionService>(context, listen: false)
        .getAdoptionsByUserId(
            userName: FirebaseAuth.instance.currentUser!.displayName);
  }

  Future<void> _deleteAdoption(Adoption adoption) {
    return Provider.of<AdoptionService>(context, listen: false)
        .deleteAdoption(id: adoption.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adoption Applications'),
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
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    'Adoptions in ${DateFormat('MMMM').format(DateTime.now())}',
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 4),
                                Text('${adoptionService.monthlyAdoptions}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Total Applications',
                                    style: TextStyle(fontSize: 16)),
                                const SizedBox(height: 4),
                                Text('${adoptionService.adoptions.length}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: adoptionService.adoptions.length,
                      itemBuilder: (context, index) {
                        final adoption = adoptionService.adoptions[index];
                        return Card(
                          child: ListTile(
                            leading: Image.asset('assets/logo.png'),
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                '${adoption.animalName} - ${adoption.status}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Applied ${timeago.format(adoption.time)}'),
                                Text('By ${adoption.userName}'),
                              ],
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      dialogBackgroundColor: Colors.white,
                                    ),
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      title: const Text(
                                        'Application Details',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          height:
                                              1.5, // Adjust line height for title
                                        ),
                                      ),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Phone: ${adoption.phone}',
                                              style: const TextStyle(
                                                  fontSize: 18, height: 1.5)),
                                          Text('Status: ${adoption.status}',
                                              style: const TextStyle(
                                                  fontSize: 18, height: 1.5)),
                                          Text(
                                              'Application: ${adoption.application}',
                                              style: const TextStyle(
                                                  fontSize: 18, height: 1.5)),
                                        ],
                                      ),
                                      actions: [
                                        StyledButton(
                                          child: const Text('Call',
                                              style: TextStyle(
                                                  fontSize: 18, height: 1.5)),
                                          onPressed: () {
                                            Uri url = Uri(
                                                scheme: 'tel',
                                                path: adoption.phone);
                                            launchUrl(url);
                                          },
                                        ),
                                        StyledButton(
                                          child: const Text('Close',
                                              style: TextStyle(
                                                  fontSize: 18, height: 1.5)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (Provider.of<ApplicationState>(context,
                                        listen: false)
                                    .isRescuer) ...[
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      //route to edit_adoption
                                      context.pushNamed(
                                        'edit-adoption',
                                        extra: adoption,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteAdoption(adoption);
                                    },
                                  ),
                                ]
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
