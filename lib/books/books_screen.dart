import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:permission_handler/permission_handler.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Book List',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final books = snapshot.data!.docs.map((doc) {
            return Book(
              id: doc.id,
              title: doc['title'],
              author: doc['author'],
              imageUrl: doc['coverImageUrl'],
              bookFileUrl: doc['bookFileUrl'],
            );
          }).toList();

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Image.network(books[index].imageUrl),
                  title: Text(
                    books[index].title,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(books[index].author),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: CircleAvatar(
                            backgroundColor: Colors.limeAccent[400],
                            child: const Icon(Icons.picture_as_pdf)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfViewerScreen(
                                  url: books[index].bookFileUrl),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete?'),
                                content: const SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('Are you sure to delete?'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      _deleteBook(context, books[index]);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
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
    );
  }

  Future<void> _deleteBook(BuildContext context, Book book) async {
    try {
      // Delete the cover image from Firebase Storage
      final coverImageRef = FirebaseStorage.instance.refFromURL(book.imageUrl);
      await coverImageRef.delete();

      // Delete the book file from Firebase Storage
      final bookFileRef = FirebaseStorage.instance.refFromURL(book.bookFileUrl);
      await bookFileRef.delete();

      // Delete the book document from Firestore
      await FirebaseFirestore.instance
          .collection('books')
          .doc(book.id)
          .delete();

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${book.title} deleted successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete ${book.title}: $e')),
        );
      }
    }
  }
}

class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final String bookFileUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.bookFileUrl,
  });
}

class PdfViewerScreen extends StatefulWidget {
  final String url;

  const PdfViewerScreen({required this.url, Key? key}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PdfController? _pdfController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndDownloadFile(widget.url);
  }

  Future<void> _checkPermissionsAndDownloadFile(String url) async {
    try {
      await _requestStoragePermission();
      String filePath = await _downloadAndSaveFile(url);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load PDF: $e')),
        );
        setState(() {
          isLoading = false;
        });
      }
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
      print('PDF downloaded to $filePath'); // Add logging
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
