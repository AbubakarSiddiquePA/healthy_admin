// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewJoinRequestPage extends StatelessWidget {
  const ViewJoinRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Join Requests',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        ),
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
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('groups')
                    .doc(request['groupId'])
                    .get(),
                builder: (context, groupSnapshot) {
                  if (groupSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  }

                  if (groupSnapshot.hasError) {
                    return ListTile(
                      title: Text(request['email']),
                      subtitle: const Text('Error loading group information'),
                    );
                  }

                  if (!groupSnapshot.hasData || !groupSnapshot.data!.exists) {
                    return Container();
                  }

                  final group = groupSnapshot.data!;
                  final isApproved = request['status'] == 'approved';

                  return Card(
                    color: Colors.limeAccent[400],
                    child: ListTile(
                      title: Text(request['email']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Group: ${group['name']}'),
                          Text('Time and Date: ${_formatTimestamp(request)}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isApproved)
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () => _approveRequest(
                                  request.id,
                                  context,
                                  request['groupId'],
                                  request['email']),
                            ),
                          if (!isApproved)
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  _rejectRequest(request.id, context),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(DocumentSnapshot request) {
    final timestamp = request['timestamp']?.toDate() ?? DateTime.now();
    String formattedTime = DateFormat('hh:mma').format(timestamp);
    String formattedDate = DateFormat('d-MMM-yyyy').format(timestamp);
    return '$formattedDate $formattedTime';
  }

  Future<void> _approveRequest(String requestId, BuildContext context,
      String groupId, String email) async {
    try {
      await FirebaseFirestore.instance
          .collection('joinRequests')
          .doc(requestId)
          .update({'status': 'approved'});

      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('users')
          .add({
        'email': email,
        'joinedAt': Timestamp.now(),
        'status': 'approved'
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request approved')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve request: $e')),
      );
    }
  }

  Future<void> _rejectRequest(String requestId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('joinRequests')
          .doc(requestId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request rejected')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject request: $e')),
      );
    }
  }
}
