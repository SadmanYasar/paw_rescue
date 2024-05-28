import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_rescue/widgets/app_state.dart';
import 'package:paw_rescue/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../models/report_model.dart';
import '../services/reports_data_service.dart';

//Create a ReportsPage screen that displays a list of reports and each report has two buttons for editing and deleting the report. After deleting the report, the list should be updated and also after editing and creating a new report, the list should be updated. For creating and updating a report, a form has to be shown with four fields: name, description, time, and address. The form should be shown in a dialog box. The reports should be fetched from the Firestore database using the reports_data_service.dart.
class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  // List<Report> reports = [];
  // final _formKey = GlobalKey<FormState>();
  // final _nameController = TextEditingController();
  // final _descriptionController = TextEditingController();
  // final _timeController = TextEditingController();
  // final _addressController = TextEditingController();
  // final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //if isRescuer show all reports
    if (Provider.of<ApplicationState>(context, listen: false).isRescuer) {
      _getReports();
    } else {
      //if not rescuer show only user reports
      _getReportsByUserId();
    }
  }

  Future<void> _getReports() {
    return Provider.of<ReportService>(context, listen: false).getReports();
  }

  // Future<void> _addReport() async {
  //   if (_formKey.currentState!.validate()) {
  //     final report = Report(
  //       name: _nameController.text,
  //       description: _descriptionController.text,
  //       time: DateTime.parse(_timeController.text),
  //       address: _addressController.text,
  //       phone: _phoneController.text,
  //       userId: FirebaseAuth.instance.currentUser!.uid,
  //       id: '',
  //     );
  //     await Provider.of<ReportService>(context, listen: false)
  //         .createReport(report: report);
  //     // Navigator.of(context).pop();
  //   }
  // }

  // Future<void> _updateReport(Report report) async {
  //   if (_formKey.currentState!.validate()) {
  //     final updatedReport = Report(
  //       name: _nameController.text,
  //       description: _descriptionController.text,
  //       time: DateTime.parse(_timeController.text),
  //       address: _addressController.text,
  //       phone: _phoneController.text,
  //       userId: FirebaseAuth.instance.currentUser!.uid,
  //       id: report.id,
  //     );
  //     await Provider.of<ReportService>(context, listen: false)
  //         .updateReport(report: updatedReport);
  //     // Navigator.of(context).pop();
  //   }
  // }

  Future<void> _getReportsByUserId() {
    return Provider.of<ReportService>(context, listen: false)
        .getReportsByUserId(userId: FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> _deleteReport(Report report) {
    return Provider.of<ReportService>(context, listen: false)
        .deleteReport(id: report.id);
  }

  // void _showForm({Report? report}) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(report == null ? 'Add Report' : 'Edit Report'),
  //         content: Form(
  //           key: _formKey,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               TextFormField(
  //                 controller: _nameController..text = report?.name ?? '',
  //                 decoration: const InputDecoration(labelText: 'Name'),
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Please enter a name';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               TextFormField(
  //                 controller: _descriptionController
  //                   ..text = report?.description ?? '',
  //                 decoration: const InputDecoration(labelText: 'Description'),
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Please enter a description';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               TextFormField(
  //                 controller: _timeController
  //                   ..text = report?.time.toString() ?? '',
  //                 decoration: const InputDecoration(labelText: 'Time'),
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Please enter a time';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   showDatePicker(
  //                     context: context,
  //                     initialDate: DateTime.now(),
  //                     firstDate: DateTime(2000),
  //                     lastDate: DateTime(2100),
  //                   ).then((selectedDate) {
  //                     if (selectedDate != null) {
  //                       showTimePicker(
  //                         context: context,
  //                         initialTime: TimeOfDay.now(),
  //                       ).then((selectedTime) {
  //                         if (selectedTime != null) {
  //                           final dateTime = DateTime(
  //                             selectedDate.year,
  //                             selectedDate.month,
  //                             selectedDate.day,
  //                             selectedTime.hour,
  //                             selectedTime.minute,
  //                           );
  //                           setState(() {
  //                             _timeController.text = dateTime.toString();
  //                           });
  //                         }
  //                       });
  //                     }
  //                   });
  //                 },
  //                 child: const Text('Select Time'),
  //               ),
  //               TextFormField(
  //                 controller: _addressController..text = report?.address ?? '',
  //                 decoration: const InputDecoration(labelText: 'Address'),
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Please enter an address';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               TextFormField(
  //                 controller: _phoneController..text = report?.phone ?? '',
  //                 decoration: const InputDecoration(labelText: 'Phone'),
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Please enter a phone number';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           StyledButton(
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           StyledButton(
  //             child: Text(report == null ? 'Add' : 'Update'),
  //             onPressed: () {
  //               if (report == null) {
  //                 _addReport();
  //                 //close the dialog
  //               } else {
  //                 _updateReport(report);
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Consumer<ReportService>(
        builder: (context, reportService, _) {
          return ListView.builder(
            itemCount: reportService.reports.length,
            itemBuilder: (context, index) {
              final report = reportService.reports[index];
              return Card(
                child: ListTile(
                  leading: Image.asset('assets/logo.png'),
                  title: Text(report.name),
                  subtitle: Text(report.address),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Report Details'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Name: ${report.name}'),
                              Text('Description: ${report.description}'),
                              Text('Time: ${report.time.toString()}'),
                              Text('Address: ${report.address}'),
                              Text('Phone: ${report.phone}'),
                            ],
                          ),
                          actions: [
                            StyledButton(
                              child: const Text('Close'),
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
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          //route to edit_report
                          context.pushNamed(
                            'edit-report',
                            extra: report,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteReport(report);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('edit-report');
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
