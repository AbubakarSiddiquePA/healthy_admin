import 'package:flutter/material.dart';
import 'package:healthy_admin/books/add_books.dart';
import 'package:healthy_admin/books/books.dart';
import 'package:healthy_admin/chat/chat.dart';
import 'package:healthy_admin/chat/chat_options.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const BooksPage(),
    const ChatPage(),
  ];

  void _onFloatingActionButtonPressed() {
    if (_currentIndex == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddBookPage(),
          ));
    } else if (_currentIndex == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatOptionsPage(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _onFloatingActionButtonPressed,
        tooltip: 'Action',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
