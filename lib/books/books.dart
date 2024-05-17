import 'package:flutter/material.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'All Added Books will be visible hear',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
