import 'package:flutter/material.dart';
import 'package:healthy_admin/books/view_editbooks.dart';

class AddBookPage extends StatelessWidget {
  const AddBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewOrEditBooks(),
                  ));
            },
          ),
        )
      ], title: const Text("Add a Book")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Book Name",
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Author Name",
              ),
            ),
            ElevatedButton(
                onPressed: () {}, child: const Text("Upload Cover Image")),
            ElevatedButton(
                onPressed: () {}, child: const Text("Upload Book File PDF")),
            ElevatedButton(onPressed: () {}, child: const Text("Save"))
          ],
        )),
      ),
    );
  }
}
