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
        boxColor: Color(0xffFFB701)));

    categories.add(CategoryModel(
        id: '2',
        name: 'Thịt',
        image_urls: 'assets/icons/chicken.png',
        boxColor: Color(0xffFD423F)));

    categories.add(CategoryModel(
        id: '3',
        name: 'Rau Củ',
        image_urls: 'assets/icons/carrot.png',
        boxColor: Color(0xff67AD00)));

    categories.add(CategoryModel(
        id: '4',
        name: 'Dụng cụ Nhà Bếp',
        image_urls: 'assets/icons/spoon.png',
        boxColor: Color(0xffFE8000)));

    return categories;
  }
}
