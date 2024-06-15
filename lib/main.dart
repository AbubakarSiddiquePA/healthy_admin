import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthy_admin/home/home.dart';
import 'package:healthy_admin/privacy_policy/privacy_policy.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool acceptedPrivacyPolicy = prefs.getBool("acceptedPrivacyPolicy") ?? false;

  runApp(MyApp(
    acceptedPrivacyPolicy: acceptedPrivacyPolicy,
  ));
}

class MyApp extends StatelessWidget {
  final bool acceptedPrivacyPolicy;
  const MyApp({super.key, required this.acceptedPrivacyPolicy});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.limeAccent),
          useMaterial3: true,
        ),
        home: acceptedPrivacyPolicy
            ? const MyHomePage(
                centerTitle: Text(
                "Healthy Admin",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ))
            : const PrivacyPolicyScreen());
  }
}
