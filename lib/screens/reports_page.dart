import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_rescue/widgets/app_state.dart';
import 'package:paw_rescue/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../models/report_model.dart';
import '../services/reports_data_service.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
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

  Future<void> _getReportsByUserId() {
    return Provider.of<ReportService>(context, listen: false)
        .getReportsByUserId(userId: FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> _deleteReport(Report report) {
    return Provider.of<ReportService>(context, listen: false)
        .deleteReport(id: report.id);
  }

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
