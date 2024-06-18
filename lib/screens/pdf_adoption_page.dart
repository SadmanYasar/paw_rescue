import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:paw_rescue/models/adoption_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PdfAdoptionScreen extends StatefulWidget {
  final Adoption adoption;
  const PdfAdoptionScreen({super.key, required this.adoption});

  @override
  State<PdfAdoptionScreen> createState() => _PdfAdoptionScreenState();
}

class _PdfAdoptionScreenState extends State<PdfAdoptionScreen> {
  final pw.Document pdf = pw.Document();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adoption Application'),
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final image = await imageFromAssetBundle('assets/logo.png');

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Center(
                  child: pw.Image(image),
                ),
              ),
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text('Adoption Application',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      )),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Text('Status: ${widget.adoption.status}',
                    style: const pw.TextStyle(fontSize: 20)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Text('Username: ${widget.adoption.userName}',
                    style: const pw.TextStyle(fontSize: 20)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Text(
                      'Date: ${DateFormat('yyyy-MM-dd HH:mm a').format(widget.adoption.time)}',
                      style: const pw.TextStyle(fontSize: 20)),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Text('Animal: ${widget.adoption.animalName}',
                    style: const pw.TextStyle(fontSize: 20)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Text('Phone: ${widget.adoption.phone}',
                    style: const pw.TextStyle(fontSize: 20)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Text('Application: ${widget.adoption.application}',
                    style: const pw.TextStyle(fontSize: 20)),
              ),
              pw.SizedBox(height: 20),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
