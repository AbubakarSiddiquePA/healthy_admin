import 'package:flutter/material.dart';

class AddBookPage extends StatelessWidget {
  const AddBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add a Book")),
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
