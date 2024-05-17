import 'package:flutter/material.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Books Page',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
