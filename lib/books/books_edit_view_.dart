// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ViewOrEditBooks extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('View and Edit Books'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('books').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           final books = snapshot.data!.docs.map((doc) {
//             return Book(
//               title: doc['title'],
//               author: doc['author'],
//               imageUrl: doc['coverImageUrl'],
//             );
//           }).toList();

//           return ListView.builder(
//             itemCount: books.length,
//             itemBuilder: (context, index) {
//               return Card(
//                 child: ListTile(
//                   leading: Image.network(books[index].imageUrl),
//                   title: Text(books[index].title),
//                   subtitle: Text(books[index].author),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.picture_as_pdf),
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: Text(books[index].title),
//                               content: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Image.network(books[index].imageUrl),
//                                   const SizedBox(height: 10),
//                                   Text('Author: ${books[index].author}'),
//                                 ],
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: const Text('Close'),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () {
//                           FirebaseFirestore.instance
//                               .collection('books')
//                               .doc(snapshot.data!.docs[index].id)
//                               .delete();
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                               content:
//                                   Text('Deleting ${books[index].title}...')));
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class Book {
//   final String title;
//   final String author;
//   final String imageUrl;

//   Book({
//     required this.title,
//     required this.author,
//     required this.imageUrl,
//   });
// }
