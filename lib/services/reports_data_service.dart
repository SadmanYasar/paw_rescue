import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/datamodel.dart';

class ReportService {
  static final ReportService _instance = ReportService._constructor();
  final db = FirebaseFirestore.instance;

  factory ReportService() {
    return _instance;
  }

  ReportService._constructor();

  Future<Report> createReport({Report? report}) async {
    try {
      final docRef = db.collection('reports').doc();
      Report newReport = Report(
          name: report!.name,
          description: report.description,
          time: report.time,
          address: report.address,
          userId: report.userId,
          phone: report.phone,
          id: docRef.id);

      await docRef.set(newReport.toJson());
      return newReport;
    } on Exception catch (e) {
      throw Exception('Failed to create report: $e');
    }
  }

  //Read all reports
  Future<List<Report>> getReports() async {
    try {
      final appointmentCollection = await db.collection('reports').get();
      print(appointmentCollection.docs);
      return appointmentCollection.docs
          .map((doc) => Report.fromJson(doc.data()))
          .toList();
    } on Exception catch (e) {
      print(e);
      throw Exception('Failed to read reports: $e');
    }
  }

  //Update report
  Future<Report> updateReport({Report? report}) async {
    try {
      await db.collection('reports').doc(report!.id).update(report.toJson());
      return report;
    } on Exception catch (e) {
      throw Exception('Failed to update report: $e');
    }
  }

  //Delete report
  Future deleteReport({String? id}) async {
    try {
      await db.collection('reports').doc(id).delete();
    } on Exception catch (e) {
      throw Exception('Failed to delete report: $e');
    }
  }
}

//final todoDataService = TodoDataServiceRest();