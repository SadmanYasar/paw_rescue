import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_rescue/widgets/app_state.dart';
import 'package:paw_rescue/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/report_model.dart';
import '../services/reports_data_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    print(Provider.of<ApplicationState>(context, listen: false).isRescuer);

    if (Provider.of<ApplicationState>(context, listen: false).isRescuer) {
      print(Provider.of<ApplicationState>(context, listen: false).isRescuer);
      Future.microtask(() => _getReports());
      // _getReports();
    } else {
      //if not rescuer show only user reports
      Future.microtask(() => _getReportsByUserId());
      // _getReportsByUserId();
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
          if (reportService.isLoading) {
            // Show a loading circle
            return const Center(child: CircularProgressIndicator()
                // child: Text('Loading'));
                );
          } else {
            if (reportService.reports.isEmpty) {
              return const Center(
                child: Text('No reports found'),
              );
            }
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
                                  'Rescues in ${DateFormat('MMMM').format(DateTime.now())}',
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('${reportService.monthlyRescues}',
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
                              const Text('Total Reports',
                                  style: TextStyle(fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('${reportService.reports.length}',
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
                    itemCount: reportService.reports.length,
                    itemBuilder: (context, index) {
                      final report = reportService.reports[index];
                      return Card(
                        child: ListTile(
                          leading: Image.asset('assets/logo.png'),
                          title: Text(
                              '${report.name} • ${timeago.format(report.time, locale: 'en_short')}'),
                          subtitle: Text(report.address),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                      dialogBackgroundColor: Colors.white),
                                  child: AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0)), // Making it look more like a card
                                    title: const Text(
                                      'Report Details',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        height:
                                            1.5, // Adjust line height for title
                                      ),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Name: ${report.name}',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  height:
                                                      1.5)), // IncreaseDd font size and line height
                                          const SizedBox(
                                              height:
                                                  8), // Adds vertical spacing
                                          Text(
                                              'Description: ${report.description}',
                                              style: const TextStyle(
                                                  fontSize: 18, height: 1.5)),
                                          const SizedBox(height: 8),
                                          Text(
                                              'Posted: ${timeago.format(report.time)}',
                                              style: const TextStyle(
                                                  fontSize: 18, height: 1.5)),
                                          const SizedBox(height: 8),
                                          Text('Address: ${report.address}',
                                              style: const TextStyle(
                                                  fontSize: 18, height: 1.5)),
                                          const SizedBox(height: 8),
                                          Text('Phone: ${report.phone}',
                                              style: const TextStyle(
                                                  fontSize: 18, height: 1.5)),
                                          const SizedBox(height: 8),
                                          Text('Rescued: ${report.rescued}',
                                              style: const TextStyle(
                                                  fontSize: 18, height: 1.5))
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      // a button than open phone call app with the phone number dialed
                                      StyledButton(
                                        child: const Text('Call',
                                            style: TextStyle(
                                                fontSize: 18, height: 1.5)),
                                        onPressed: () {
                                          Uri url = Uri(
                                              scheme: 'tel',
                                              path: report.phone);
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
                              if (!Provider.of<ApplicationState>(context,
                                      listen: false)
                                  .isRescuer)
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
                              if (!Provider.of<ApplicationState>(context,
                                      listen: false)
                                  .isRescuer)
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
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton:
          !Provider.of<ApplicationState>(context, listen: false).isRescuer
              ? FloatingActionButton(
                  onPressed: () {
                    context.pushNamed('edit-report');
                  },
                  child: const Icon(Icons.add),
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
