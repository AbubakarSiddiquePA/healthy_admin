import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "About",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      body: const Center(
        child: Text(
          "Designed and Developed by \nAbubakar Siddique PA",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
