// user_list_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserListPage extends StatelessWidget {
  final String groupId;
  final String groupName;

  const UserListPage({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Users in $groupName',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .collection('users')
            .where('status', isEqualTo: 'approved')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No users in this group yet.'),
            );
          }

          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['email']),
                subtitle:
                    Text('Joined on: ${_formatTimestamp(user['joinedAt'])}'),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('groups')
                        .doc(groupId)
                        .collection('users')
                        .doc(user.id)
                        .delete();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User removed from group')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    String formattedTime = DateFormat('hh:mma').format(date);
    String formattedDate = DateFormat('d-MMM-yyyy').format(date);
    return '$formattedDate $formattedTime';
  }
}
