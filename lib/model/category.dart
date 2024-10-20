import 'package:flutter/cupertino.dart';

class CategoryModel {
  String id;
  String name;
  String image_urls;
  Color boxColor;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image_urls,
    required this.boxColor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(CategoryModel(
        id: '1',
        name: 'All',
        image_urls: 'assets/icons/hamburger.png',
        boxColor: const Color(0xffFFB701)));

    categories.add(CategoryModel(
        id: '2',
        name: 'Thịt',
        image_urls: 'assets/icons/chicken.png',
        boxColor: const Color(0xffFF9310)));

    categories.add(CategoryModel(
        id: '3',
        name: 'Rau Củ',
        image_urls: 'assets/icons/carrot.png',
        boxColor: const Color(0xff67AD00)));

    categories.add(CategoryModel(
        id: '4',
        name: 'Dụng cụ',
        image_urls: 'assets/icons/spoon.png',
        boxColor: const Color(0xffFE8000)));

    return categories;
  }
}
