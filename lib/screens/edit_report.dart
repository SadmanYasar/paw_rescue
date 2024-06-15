//edit_report.dart
import 'package:flutter/material.dart';
import 'package:paw_rescue/models/report_model.dart';
import 'package:paw_rescue/services/reports_data_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditReportScreen extends StatefulWidget {
  final Report? report;

  const EditReportScreen({super.key, this.report});

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _rescuedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.report != null) {
      _nameController.text = widget.report!.name;
      _descriptionController.text = widget.report!.description;
      _timeController.text = widget.report!.time.toString();
      _addressController.text = widget.report!.address;
      _phoneController.text = widget.report!.phone;
      _rescuedController.text = widget.report!.rescued;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.report == null ? 'Create Report' : 'Edit Report'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nameController.text = value!;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _descriptionController.text = value!;
                  },
                ),
                TextFormField(
                    controller: _timeController,
                    decoration: const InputDecoration(labelText: 'Time'),
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a time';
                      }
                      return null;
                    },
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          final dateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                          //format dateTime to make it displayable in YYYY-MM-DD HH:MM format
                          String formattedDateTime =
                              '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
                          _timeController.text = formattedDateTime;
                        }
                      }
                    }),
                // ElevatedButton(
                //   style: ButtonStyle(
                //     //make it full width
                //     minimumSize: MaterialStateProperty.all<Size>(
                //       const Size(double.infinity, 50),
                //     ),
                //     //add padding to the button
                //     padding: MaterialStateProperty.all<EdgeInsets>(
                //       const EdgeInsets.all(16.0),
                //     ),
                //   ),
                //   onPressed: () {
                //     showDatePicker(
                //       context: context,
                //       initialDate: DateTime.now(),
                //       firstDate: DateTime(2000),
                //       lastDate: DateTime(2100),
                //     ).then((selectedDate) {
                //       if (selectedDate != null) {
                //         showTimePicker(
                //           context: context,
                //           initialTime: TimeOfDay.now(),
                //         ).then((selectedTime) {
                //           if (selectedTime != null) {
                //             final dateTime = DateTime(
                //               selectedDate.year,
                //               selectedDate.month,
                //               selectedDate.day,
                //               selectedTime.hour,
                //               selectedTime.minute,
                //             );
                //             _timeController.text = dateTime.toString();
                //           }
                //         });
                //       }
                //     });
                //   },
                //   child: const Text('Select Time'),
                // ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _addressController.text = value!;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _phoneController.text = value!;
                  },
                ),
                if (widget.report != null)
                  TextFormField(
                    controller: _rescuedController,
                    decoration: const InputDecoration(
                        labelText: 'Rescued? (true/false)'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a rescued';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _rescuedController.text = value!;
                    },
                  ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ButtonStyle(
                    //make it full width
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 50),
                    ),
                    //add padding to the button
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(16.0),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final report = Report(
                        name: _nameController.text,
                        description: _descriptionController.text,
                        time: DateTime.parse(_timeController.text),
                        address: _addressController.text,
                        phone: _phoneController.text,
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        rescued: _rescuedController.text,
                        id: widget.report?.id,
                      );
                      if (widget.report == null) {
                        Provider.of<ReportService>(context, listen: false)
                            .createReport(report: report)
                            .then((value) => Navigator.pop(context));
                      } else {
                        Provider.of<ReportService>(context, listen: false)
                            .updateReport(report: report)
                            .then((value) => Navigator.pop(context));
                      }
                    }
                  },
                  child: Text(widget.report == null ? 'Create' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
