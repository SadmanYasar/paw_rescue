import 'package:flutter/material.dart';
import 'package:paw_rescue/services/medicine_data_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _getMedicines());
  }

  Future<void> _getMedicines() {
    return Provider.of<MedicineService>(context, listen: false).getMedicines();
  }

  @override
  Widget build(BuildContext context) {
    final medicineService = Provider.of<MedicineService>(context);
    final medicines = medicineService.medicines;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medications'),
      ),
      body: Consumer<MedicineService>(
        builder: (context, medicineService, _) {
          if (medicineService.isLoading && medicines.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: medicines.length,
            itemBuilder: (context, index) {
              final medicine = medicines[index];

              return InkWell(
                onTap: () => {
                  launchUrl(Uri.parse(medicine.productLink),
                      mode: LaunchMode.inAppBrowserView)
                },
                child: Container(
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
                          image: Image.network(medicine.imageURL).image,
                          fit: BoxFit.cover,
                          height: 240,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'RM${medicine.price}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade500),
                                ),
                              ),
                              Text(
                                medicine.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                medicine.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
