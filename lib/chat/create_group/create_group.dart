import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  String _groupName = "";
  String _groupDescription = "";

  Future<void> createGroup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseFirestore.instance.collection("groups").add({
          "name": _groupName,
          "description": _groupDescription,
          "coverImage": 'assets/images/images.jpeg'
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Group Created Successfully")));
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to create group:$e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: createGroup, child: const Text("Create Group")),
        ],
        title: const Text("Create Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a group name';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _groupName = newValue!;
                  },
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a group description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _groupDescription = value!;
                  },
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
