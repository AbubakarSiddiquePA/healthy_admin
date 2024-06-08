import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthy_admin/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid
          ? const FirebaseOptions(
              apiKey: "AIzaSyB30O8Vi4uU8WynuuTyrPVGxah0tJ7LU_Y",
              appId: "1:764846460901:android:19d80dd753538ccc65a90c",
              messagingSenderId: "764846460901",
              projectId: "healthy-a9610",
              storageBucket: "healthy-a9610.appspot.com",
            )
          : null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.limeAccent),
        useMaterial3: true,
      ),
      home: const Center(
        child: MyHomePage(
          centerTitle: Center(
            child: Text(
              "Healthy Admin",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          // title: ' Healthy Admin',
        ),
      ),
    );
  }
}
