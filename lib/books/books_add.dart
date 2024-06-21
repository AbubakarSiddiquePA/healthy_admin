import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _author = '';
  File? _coverImage;
  File? _bookFile;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickCoverImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null && mounted) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickCoverImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickCoverImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickBookFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && mounted) {
      setState(() {
        _bookFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadBook() async {
    if (_formKey.currentState!.validate() &&
        _coverImage != null &&
        _bookFile != null) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        // Upload cover image
        final coverImageRef = FirebaseStorage.instance
            .ref()
            .child('book_covers/${_coverImage!.path.split('/').last}');
        await coverImageRef.putFile(_coverImage!);
        final coverImageUrl = await coverImageRef.getDownloadURL();

        // Upload book file
        final bookFileRef = FirebaseStorage.instance
            .ref()
            .child('books/${_bookFile!.path.split('/').last}');
        await bookFileRef.putFile(_bookFile!);
        final bookFileUrl = await bookFileRef.getDownloadURL();

        // Save book data to Firestore
        await FirebaseFirestore.instance.collection('books').add({
          'title': _title,
          'author': _author,
          'coverImageUrl': coverImageUrl,
          'bookFileUrl': bookFileUrl,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
            'Book added successfully',
            style: TextStyle(color: Colors.green),
          )));
          Navigator.of(context).pop(); // Pop the screen after success
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to add book: $e',
                  style: const TextStyle(color: Colors.green))));
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill all fields and select files')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add a Book",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Book Name",
                    hintText: "Please enter Book name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Colors.limeAccent[400],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter book Name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Please enter Author Name",
                    labelText: "Author Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Colors.limeAccent[400],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter author name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _author = value!;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_coverImage != null)
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: FileImage(_coverImage!),
                      )
                    else
                      const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person),
                      ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showImageSourceActionSheet(context),
                      label: const Text(
                        "Upload Cover Image",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      icon: const Icon(Icons.upload),
                    ),
                  ],
                ),
                // const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ElevatedButton.icon(
                    onPressed: _pickBookFile,
                    label: const Text(
                      "Upload Book File (PDF)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    icon: const Icon(Icons.upload),
                  ),
                ]),
                if (_bookFile != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Selected PDF: ${_bookFile!.path.split('/').last}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: (_coverImage != null &&
                              _bookFile != null &&
                              !_isLoading)
                          ? _uploadBook
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.limeAccent[400],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
