import 'package:flutter/material.dart';

class CreateGroupPage extends StatelessWidget {
  const CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Group Name",
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Group Description",
              ),
            ),
            ElevatedButton(
                onPressed: () {},
                child: const Text("Upload Group Cover Image")),
            ElevatedButton(onPressed: () {}, child: const Text("Create Group")),
          ],
        )),
      ),
    );
  }
}
