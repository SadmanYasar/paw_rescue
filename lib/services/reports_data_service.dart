import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';
import 'package:flutter/foundation.dart';

class ReportService extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  List<Report> reports = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> createReport({Report? report}) async {
    try {
      _isLoading = true;
      notifyListeners();

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
      reports.add(newReport);

      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e.toString());
      throw Exception('Failed to create report: $e');
    }
  }

  //Read all reports
  Future<void> getReports() async {
    try {
      final appointmentCollection = await db.collection('reports').get();
      reports = appointmentCollection.docs
          .map((doc) => Report.fromJson(doc.data()))
          .toList();

      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to read reports: $e');
    }
  }

  Future<void> getReportsByUserId({String? userId}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final appointmentCollection = await db
          .collection('reports')
          .where('userId', isEqualTo: userId)
          .get();
      reports = appointmentCollection.docs
          .map((doc) => Report.fromJson(doc.data()))
          .toList();

      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to read reports: $e');
    }
  }

  //Update report
  Future<void> updateReport({Report? report}) async {
    try {
      _isLoading = true;
      notifyListeners();

      await db.collection('reports').doc(report!.id).update(report.toJson());
      final index = reports.indexWhere((element) => element.id == report.id);
      reports[index] = report;

      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to update report: $e');
    }
  }

  //Delete report
  Future deleteReport({String? id}) async {
    try {
      _isLoading = true;
      notifyListeners();

      await db.collection('reports').doc(id).delete();
      reports.removeWhere((element) => element.id == id);

      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e.toString());
      throw Exception('Failed to delete report: $e');
    }
  }
}
