import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewJoinRequestPage extends StatelessWidget {
  const ViewJoinRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('joinRequests').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Join Requests');
            }

            if (snapshot.hasError) {
              return const Text('Error');
            }

            final requestCount = snapshot.data!.docs.length;
            return Row(
              children: [
                Text('Join Requests: $requestCount'),
              ],
            );
          },
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

                  if (groupSnapshot.hasError ||
                      !groupSnapshot.hasData ||
                      !groupSnapshot.data!.exists) {
                    return const ListTile(
                      title: Text('Group not found'),
                    );
                  }

                  final group = groupSnapshot.data!;
                  return Card(
                    color: Colors.white24,
                    child: ListTile(
                      title: Text(request['email']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Group: ${group['name']}'),
                          Text('Times and Date: ${_formatTimestamp(request)}'),
                        ],
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
    // DateTime timestamp = request['timestamp']?.toDate();
    // Format timestamp as 'id now' where 'id' is the current hour and minute
    String formattedTime = DateFormat('hh:mma').format(DateTime.now());
    // Format today's date as '5-May-2024'
    String formattedDate = DateFormat('d-MMM-yyyy').format(DateTime.now());
    return '$formattedDate $formattedTime';
  }
}

Future<void> _approveRequest(String requestId) async {
  await FirebaseFirestore.instance
      .collection('joinRequests')
      .doc(requestId)
      .update({'status': 'approved'});
}

Future<void> _rejectRequest(String requestId) async {
  await FirebaseFirestore.instance
      .collection('joinRequests')
      .doc(requestId)
      .delete();
}
