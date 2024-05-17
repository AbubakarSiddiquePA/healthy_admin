import 'package:flutter/material.dart';
import 'package:healthy_admin/chat/create_group/create_group.dart';
import 'package:healthy_admin/chat/join_request/view_join_request.dart';

class ChatOptionsPage extends StatelessWidget {
  const ChatOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ChatOptions")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateGroupPage(),
                      ));
                },
                child: const Text("Create Group")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewJoinRequestPage(),
                      ));
                },
                child: const Text("View Join Request")),
          ],
        ),
      ),
    );
  }
}
