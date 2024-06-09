import 'package:flutter/material.dart';
import 'package:healthy_admin/books/books_add.dart';
import 'package:healthy_admin/books/books_screen.dart';
import 'package:healthy_admin/chat/chat_card.dart';
import 'package:healthy_admin/chat/create_group/chat_create_group.dart';
import 'package:healthy_admin/chat/join_request/chat_view_join_request.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.centerTitle});

  final Widget centerTitle;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  late List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      const BookListScreen(),
      communityItems(context),
    ];
  }

  void _onFloatingActionButtonPressed() {
    if (_currentIndex == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddBookPage(),
          ));
    } else if (_currentIndex == 1) {
      showBottomSheet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: widget.centerTitle,
      ),
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.limeAccent[400],
        onPressed: _onFloatingActionButtonPressed,
        tooltip: 'Action',
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(color: Colors.limeAccent[400]),
        selectedFontSize: 18,
        iconSize: 16,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(label: "Books", icon: Icon(Icons.book)),
          BottomNavigationBarItem(label: "Chat", icon: Icon(Icons.chat)),
        ],
      ),
    );
  }
}

void showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.grey,
    elevation: 1,
    context: context,
    builder: (BuildContext context) {
      return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.limeAccent[400],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  "Close",
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
            const Divider(
              color: Colors.white,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.create),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              label: const Text(
                "Create Group",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateGroupPage(),
                    ));
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(Icons.person),
              label: const Text(
                "View Join Request",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewJoinRequestPage(),
                    ));
              },
            ),
          ],
        ),
      );
    },
  );
}
