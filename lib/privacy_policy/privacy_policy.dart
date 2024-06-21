// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:healthy_admin/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _accepted = false;

  Future<void> _onAccept() async {
    if (_accepted) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('acceptedPrivacyPolicy', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const MyHomePage(centerTitle: Text("Healthy Admin"))),
      );
    }
  }

  Future<void> _launchPrivacyPolicyUrl() async {
    final Uri url = Uri.parse("https://sites.google.com/view/healthy0090/home");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("We are unable to open the URL at the moment")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage("assets/images/1.jpg"),
            ),
            const SizedBox(height: 20),
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  const Text(
                    "By clicking 'I accept the privacy policy,' you agree to the terms of our privacy policy, which describes how our app handles data on this device.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: _launchPrivacyPolicyUrl,
                      child: const Text(
                        "Privacy Policy",
                        style: TextStyle(color: Colors.blue),
                      ))
                ]),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  checkColor: Colors.green,
                  value: _accepted,
                  onChanged: (value) {
                    setState(() {
                      _accepted = value!;
                    });
                  },
                ),
                const Expanded(
                  child: Text('I accept the privacy policy'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _accepted ? _onAccept : null,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
