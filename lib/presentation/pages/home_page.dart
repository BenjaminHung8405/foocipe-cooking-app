import 'package:flutter/material.dart';
import 'package:foocipe_cooking_app/model/category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];

  void _getInitialInfo() {
    categories = CategoryModel.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    _getInitialInfo;
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
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 120,
              child: ListView.separated(
                itemCount: categories.length,
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(
                  width: 25,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color: categories[index].boxColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                    image: AssetImage(
                                        categories[index].image_urls))),
                          ),
                          Text(
                            categories[index].name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          )
                        ]),
                  );
                },
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
