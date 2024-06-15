import 'package:flutter/material.dart';
import 'package:paw_rescue/services/medicine_data_service.dart';
import 'package:provider/provider.dart';

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
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final medicine = medicines[index];

                return Card(
                  child: ListTile(
                    title: Text(medicine.name),
                    subtitle: Text(medicine.description),
                    trailing: Text('\$${medicine.price.toStringAsFixed(2)}'),
                  ),
                );
              });
        },
      ),
    );
  }
}
