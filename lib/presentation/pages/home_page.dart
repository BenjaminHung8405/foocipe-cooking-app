import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            _searchField(),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Category',
                style: TextStyle(
                    color: Color(0xFF3E5481),
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _searchField() {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 50, right: 50),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF4F5F7),
            contentPadding: const EdgeInsets.all(15),
            hintText: 'Search',
            hintStyle: const TextStyle(color: Color(0xffDDDADA), fontSize: 14),
            prefixIcon: Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.search_rounded),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
