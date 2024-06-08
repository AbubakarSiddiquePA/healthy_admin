import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildCommunityCard(
    BuildContext context,
    // String imageUrl,
    String title,
    Function() onTap) {
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
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                ),
              ),
            ),
            // imageUrl.startsWith('http')
            // Image.network(
            //   imageUrl,
            //   width: 90,
            //   height: 90,
            //   fit: BoxFit.cover,
            // ),
            // : Image.asset(
            //     "assets/images/loveeee.jpeg",
            //     width: 90,
            //     height: 90,
            //     fit: BoxFit.cover,
            //   ),
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
      return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        children: groups.map((group) {
          final data = group.data() as Map<String, dynamic>;

          // Check if 'coverImage' exists and is not null, otherwise use a default image
          // String coverImageUrl = data['coverImage']; // default image URL

          return buildCommunityCard(
            context,
            // coverImageUrl,
            data['name'],
            () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (ctx) => Group(groupId: group.id),
              //   ),
              // );
            },
          );
        }).toList(),
      );
    },
  );
}
