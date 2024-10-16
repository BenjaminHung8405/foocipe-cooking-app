import 'package:flutter/material.dart';

class MyRecipePage extends StatelessWidget {
  const MyRecipePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('My Recipe Content'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/recipe/add');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
