// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:healthy_admin/books/books_pdf_view.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '''Book's List''',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                margin: const EdgeInsets.all(14),
                // borderOnForeground: true,
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      _showEnlargedImage(context, books[index].imageUrl);
                    },
                    child: Image.network(books[index].imageUrl),
                  ),
                  title: Text(books[index].title),
                  subtitle: Text(books[index].author),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${book.title} deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete ${book.title}: $e')),
      );
    }
  }
}

void _showEnlargedImage(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(imageUrl),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"))
          ],
        ),
      );
    },
  );
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
