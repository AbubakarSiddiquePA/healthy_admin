// import 'package:flutter/material.dart';

// class JoinRequest {
//   final String email;

//   JoinRequest({required this.email});
// }

// class ViewJoinRequestPage extends StatelessWidget {
//   ViewJoinRequestPage({super.key});

//   final List<JoinRequest> joinRequests = [
//     JoinRequest(email: 'user1@example.com'),
//     JoinRequest(email: 'user2@example.com'),
//     JoinRequest(email: 'user3@example.com'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: Text(
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 "Requests: ${joinRequests.length}"),
//           )
//         ],
//         title: const Text('Join Requests'),
//       ),
//       body: ListView.builder(
//         itemCount: joinRequests.length,
//         itemBuilder: (context, index) {
//           return Card(
//             child: ListTile(
//               title: Text(
//                   '${joinRequests[index].email} has requested to join the group'),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.check, color: Colors.green),
//                     onPressed: () {
//                       // Implement accept request functionality
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                             content: Text(
//                                 'Accepted request from ${joinRequests[index].email}')),
//                       );
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.red),
//                     onPressed: () {
//                       // Implement reject request functionality
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                             content: Text(
//                                 'Rejected request from ${joinRequests[index].email}')),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewJoinRequestPage extends StatelessWidget {
  const ViewJoinRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('joinRequests')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final requests = snapshot.data!.docs;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return ListTile(
                title: Text(request['email']),
                subtitle: Text(
                  request['timestamp'] != null
                      ? request['timestamp'].toDate().toString()
                      : 'Pending',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () => _approveRequest(request.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => _rejectRequest(request.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _approveRequest(String requestId) async {
    // Update the request status or add the user to the group, then delete the request
    await FirebaseFirestore.instance
        .collection('joinRequests')
        .doc(requestId)
        .delete();
  }

  Future<void> _rejectRequest(String requestId) async {
    // Simply delete the request
    await FirebaseFirestore.instance
        .collection('joinRequests')
        .doc(requestId)
        .delete();
  }
}
