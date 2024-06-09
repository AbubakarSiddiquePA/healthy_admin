import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_admin/chat/join_request/chat_users_list.dart';

Widget buildCommunityCard(
  BuildContext context,
  String groupId,
  String title,
  Function() onTap,
) {
  return InkWell(
    onTap: onTap,
    child: Card(
      elevation: 10,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(width: 1, color: Colors.black),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: Colors.limeAccent[400],
                child: const FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget communityItems(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('groups').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      final groups = snapshot.data!.docs;
      return SingleChildScrollView(
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.2,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          children: groups.map((group) {
            final data = group.data() as Map<String, dynamic>;

            return buildCommunityCard(
              context,
              group.id,
              data['name'],
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => UserListPage(
                      groupId: group.id,
                      groupName: data['name'],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      );
    },
  );
}
