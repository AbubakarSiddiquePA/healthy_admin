import 'package:flutter/material.dart';

class Book {
  final String title;
  final String author;
  final String imageUrl;

  Book({
    required this.title,
    required this.author,
    required this.imageUrl,
  });
}

class ViewOrEditBooks extends StatelessWidget {
  ViewOrEditBooks({super.key});

  final List<Book> books = [
    Book(
      title: 'Atomic Habits',
      author: 'Author 1',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Book(
      title: 'Discipline Equals Freedom',
      author: 'Author 2',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Book(
      title: 'Goatlife',
      author: 'Author 3',
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View and Edit Books'),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image.network(books[index].imageUrl),
              title: Text(books[index].title),
              subtitle: Text(books[index].author),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () {
                      // Implement view book functionality
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(books[index].title),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(books[index].imageUrl),
                              const SizedBox(height: 10),
                              Text('Author: ${books[index].author}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(color: Colors.red, Icons.delete),
                    onPressed: () {
                      // Implement download book functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Deleting ${books[index].title}...'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
