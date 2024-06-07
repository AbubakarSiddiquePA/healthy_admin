import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerScreen extends StatefulWidget {
  final String url;

  const PdfViewerScreen({required this.url, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PdfController? _pdfController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadAndLoadPdf(widget.url);
  }

  Future<void> _downloadAndLoadPdf(String url) async {
    try {
      final response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/temp.pdf';
      final file = File(filePath);
      await file.writeAsBytes(response.data);

      if (mounted) {
        setState(() {
          _pdfController = PdfController(
            document: PdfDocument.openFile(filePath),
          );
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to load PDF: $e')));
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read PDF'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pdfController != null
              ? PdfView(controller: _pdfController!)
              : const Center(child: Text('Failed to load PDF')),
    );
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }
}
