import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'All Chats or communities will be in this Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
