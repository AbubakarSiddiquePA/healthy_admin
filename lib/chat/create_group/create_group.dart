import 'package:flutter/material.dart';

class CreateGroupPage extends StatelessWidget {
  const CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(onPressed: () {}, child: const Text("Create Group")),
        ],
        title: const Text("Create Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.group),
                suffixIconColor: Colors.limeAccent,
                border: OutlineInputBorder(),
                hintText: "Enter Group Name ",
                labelText: "Group Name",
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.abc),
                suffixIconColor: Colors.limeAccent,
                border: OutlineInputBorder(),
                hintText: "Enter Group Description ",
                labelText: "Group Description",
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircleAvatar(
                    child: Image.asset("assets/images/images.jpeg"),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {},
                    child: const Text("Upload Group Cover Image")),
              ],
            ),
            const SizedBox(height: 10),
          ],
        )),
      ),
    );
  }
}
