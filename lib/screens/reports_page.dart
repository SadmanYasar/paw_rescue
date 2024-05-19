import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paw_rescue/widgets/widgets.dart';

import '../models/datamodel.dart';
import '../services/reports_data_service.dart';

//Create a ReportsPage screen that displays a list of reports and each report has two buttons for editing and deleting the report. After deleting the report, the list should be updated and also after editing and creating a new report, the list should be updated. For creating and updating a report, a form has to be shown with four fields: name, description, time, and address. The form should be shown in a dialog box. The reports should be fetched from the Firestore database using the reports_data_service.dart.
class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<Report> reports = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  final _addressController = TextEditingController();
  final reportService = ReportService();

  @override
  void initState() {
    super.initState();
    _getReports();
  }

  void _getReports() async {
    try {
      final reports = await reportService.getReports();
      if (mounted) {
        setState(() {
          this.reports = reports;
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void _addReport() async {
    if (_formKey.currentState!.validate()) {
      final report = Report(
        id: '',
        userId: FirebaseAuth.instance.currentUser!.uid,
        name: _nameController.text,
        description: _descriptionController.text,
        time: DateTime.parse(_timeController.text),
        address: _addressController.text,
      );
      await reportService.createReport(report: report);
      if (mounted) {
        _getReports();
        // Navigator.of(context).pop();
      }
    }
  }

  void _updateReport(Report report) async {
    if (_formKey.currentState!.validate()) {
      final updatedReport = Report(
        id: report.id,
        userId: FirebaseAuth.instance.currentUser!.uid,
        name: _nameController.text,
        description: _descriptionController.text,
        time: DateTime.parse(_timeController.text),
        address: _addressController.text,
      );
      await reportService.updateReport(report: updatedReport);
      _getReports();
    }
  }

  void _deleteReport(String id) async {
    await reportService.deleteReport(id: id);
    _getReports();
  }

  void _showForm({Report? report}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(report == null ? 'Add Report' : 'Edit Report'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController..text = report?.name ?? '',
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController
                    ..text = report?.description ?? '',
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _timeController
                    ..text = report?.time.toString() ?? '',
                  decoration: InputDecoration(labelText: 'Time'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a time';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((selectedTime) {
                          if (selectedTime != null) {
                            final dateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                            setState(() {
                              _timeController.text = dateTime.toString();
                            });
                          }
                        });
                      }
                    });
                  },
                  child: Text('Select Time'),
                ),
                TextFormField(
                  controller: _addressController..text = report?.address ?? '',
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
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
              child: Text(report == null ? 'Add' : 'Update'),
              onPressed: () {
                if (report == null) {
                  _addReport();
                  //close the dialog
                } else {
                  _updateReport(report);
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
        title: Text('Reports Page'),
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card(
            child: ListTile(
              leading: Image.asset('assets/logo.png'),
              title: Text(report.name),
              subtitle: Text(report.address),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showForm(report: report);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteReport(report.id!);
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
