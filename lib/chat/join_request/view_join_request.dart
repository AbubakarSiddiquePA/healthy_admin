import 'package:flutter/material.dart';

class ViewJoinRequestPage extends StatelessWidget {
  const ViewJoinRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Requests'),
      ),
      body: Center(
        child: Text(
          'You have X join requests',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
