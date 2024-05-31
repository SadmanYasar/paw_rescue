import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_rescue/services/animal_data_service.dart';
import 'package:paw_rescue/widgets/app_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _getAnimals();
  }

  Future<void> _getAnimals() {
    return Provider.of<AnimalService>(context, listen: false).getAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Image.asset(
            'assets/logo.png',
            width: 128,
            height: 128,
          ),
          //a horizontal stack with heading icon with paw and a text saying Paw Rescue
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pets,
                size: 48,
              ),
              Text(
                'Paw Rescue',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Adopt an animal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Consumer<AnimalService>(
            builder: (context, animalService, _) {
              if (animalService.isLoading) {
                // Show a loading circle
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (animalService.animals.isEmpty) {
                  return const Center(
                    child: Text('No animals found'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: animalService.animals.length,
                  itemBuilder: (context, index) {
                    final animal = animalService.animals[index];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Ink.image(
                              image: Image.network(animal.imageURL).image,
                              fit: BoxFit.cover,
                              height: 240,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        animal.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(animal.breed),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () {
                                      context.pushNamed('edit-animal',
                                          extra: animal);
                                    },
                                    child: const Text("Edit"),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton:
          Provider.of<ApplicationState>(context, listen: false).isRescuer
              ? FloatingActionButton(
                  onPressed: () {
                    context.pushNamed('edit-animal');
                  },
                  child: const Icon(Icons.add),
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
