import 'package:flutter/material.dart';

class MyRecipePage extends StatelessWidget {
  const MyRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('My Recipe Content'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/recipe/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
