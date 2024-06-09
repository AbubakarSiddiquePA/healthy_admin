import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityDetailsPage extends StatefulWidget {
  final String groupId;
  final String groupName;

  const CommunityDetailsPage({
    Key? key,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  @override
  _CommunityDetailsPageState createState() => _CommunityDetailsPageState();
}

class _CommunityDetailsPageState extends State<CommunityDetailsPage> {
  Future<void> removeUser(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('users')
          .doc(userId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User removed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupId)
            .collection('users')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return const Center(child: Text('No users in this community yet'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(user['name']),
                subtitle: Text(user['email']),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: () => removeUser(users[index].id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
