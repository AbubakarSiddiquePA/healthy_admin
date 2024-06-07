import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  String _groupName = "";
  String _groupDescription = "";
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> createGroup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? coverImageUrl;
      if (_imageFile != null) {
        coverImageUrl = await uploadImageToFirebase(_imageFile!);
      } else {
        coverImageUrl = 'assets/images/images.jpeg'; // default image
      }
      try {
        await FirebaseFirestore.instance.collection("groups").add({
          "name": _groupName,
          "description": _groupDescription,
          "coverImage": coverImageUrl,
        });
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Group Created Successfully")));
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to create group: $e")));
      }
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('group_cover_images/${DateTime.now().toString()}.jpg');
    final uploadTask = storageRef.putFile(imageFile);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
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
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.limeAccent[400],
                    suffixIcon: Icon(Icons.group),
                    suffixIconColor: Colors.black,
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
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.limeAccent[400],
                    suffixIcon: Icon(Icons.abc),
                    suffixIconColor: Colors.black,
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
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : const AssetImage("assets/images/images.jpeg")
                              as ImageProvider,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => pickImage(ImageSource.gallery),
                          child: const Text("Pick from Gallery"),
                        ),
                        ElevatedButton(
                          onPressed: () => pickImage(ImageSource.camera),
                          child: const Text("Take a Photo"),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            )),
      ),
    );
  }
}
