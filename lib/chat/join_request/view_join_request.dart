import 'package:flutter/material.dart';

class JoinRequest {
  final String email;

  JoinRequest({required this.email});
}

class ViewJoinRequestPage extends StatelessWidget {
  ViewJoinRequestPage({super.key});

  final List<JoinRequest> joinRequests = [
    JoinRequest(email: 'user1@example.com'),
    JoinRequest(email: 'user2@example.com'),
    JoinRequest(email: 'user3@example.com'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                "Requests: ${joinRequests.length}"),
          )
        ],
        title: const Text('Join Requests'),
      ),
      body: ListView.builder(
        itemCount: joinRequests.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(
                  '${joinRequests[index].email} has requested to join the group'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      // Implement accept request functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Accepted request from ${joinRequests[index].email}')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      // Implement reject request functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Rejected request from ${joinRequests[index].email}')),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
