import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;

  PDFViewerPage({required this.pdfUrl});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localFilePath;
  bool isLoading = true;
  PDFViewController? _pdfController;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndDownloadFile(widget.pdfUrl);
  }

  Future<void> _checkPermissionsAndDownloadFile(String url) async {
    try {
      await _requestStoragePermission();
      String filePath = await _downloadAndSaveFile(url);
      setState(() {
        localFilePath = filePath;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download PDF: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return;
    } else {
      throw Exception('Storage permission not granted');
    }
  }

  Future<String> _downloadAndSaveFile(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/temp.pdf';

    try {
      await Dio().download(url, filePath);
      return filePath;
    } catch (e) {
      throw Exception('Error downloading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localFilePath!,
              autoSpacing: true,
              enableSwipe: true,
              pageSnap: true,
              swipeHorizontal: true,
              onViewCreated: (PDFViewController pdfViewController) {
                _pdfController = pdfViewController;
              },
              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to load PDF: $error')),
                );
              },
              onRender: (_pages) {
                // Optionally handle render callback
              },
            ),
    );
  }
}
