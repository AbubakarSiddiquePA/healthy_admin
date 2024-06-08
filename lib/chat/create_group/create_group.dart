import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  String _groupName = "";
  String _groupDescription = "";
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isCreating = false;

  Future<void> createGroup() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      _formKey.currentState!.save();
      setState(() {
        _isCreating = true;
      });

      try {
        String coverImageUrl = await uploadImageToFirebase(_imageFile!);

        await FirebaseFirestore.instance.collection("groups").add({
          "name": _groupName,
          "description": _groupDescription,
          "coverImage": coverImageUrl,
        });

        if (mounted) {
          await Flushbar(
            message: 'Group Created Successfully',
            duration: const Duration(seconds: 3),
            flushbarPosition:
                FlushbarPosition.TOP, // Position the Flushbar at the top
          ).show(context);

          Navigator.pop(context,
              true); // Pop to chat screen (pass true to indicate success)
        }
      } catch (e) {
        await Flushbar(
          message: 'Failed to create group: $e',
          duration: const Duration(seconds: 3),
          flushbarPosition:
              FlushbarPosition.TOP, // Position the Flushbar at the top
        ).show(context);
      } finally {
        setState(() {
          _isCreating = false;
        });
      }
    } else {
      await Flushbar(
        message: 'Please fill all fields and select an image',
        duration: const Duration(seconds: 3),
        flushbarPosition:
            FlushbarPosition.TOP, // Position the Flushbar at the top
      ).show(context);
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
          ElevatedButton.icon(
            label: const Text(
              "Create",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            icon: const Icon(
              Icons.create,
              color: Colors.black,
            ),
            onPressed: createGroup,
          ),
        ],
        title: const Text(
          "Create Group",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
        ),
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
                  suffixIcon: const Icon(Icons.group),
                  suffixIconColor: Colors.black,
                  border: const OutlineInputBorder(),
                  hintText: "Enter Group Name",
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
                  suffixIcon: const Icon(Icons.abc),
                  suffixIconColor: Colors.black,
                  border: const OutlineInputBorder(),
                  hintText: "Enter Group Description",
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
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.upload,
                          color: Colors.black,
                        ),
                        label: const Text(
                          "Pick from Gallery",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        onPressed: () => pickImage(ImageSource.gallery),
                      ),
                      ElevatedButton.icon(
                        label: const Text(
                          "Take a Photo",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        icon: const Icon(Icons.camera),
                        onPressed: () => pickImage(ImageSource.camera),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
