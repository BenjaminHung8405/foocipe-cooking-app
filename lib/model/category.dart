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
        id: 1,
        name: 'All',
        image_urls: 'assets/icons/hamburger.png',
        boxColor: Color(0xff92A3FD)));

    categories.add(CategoryModel(
        id: 2,
        name: 'Thịt',
        image_urls: 'assets/icons/chicken.png',
        boxColor: Color(0xff92A3FD)));

    categories.add(CategoryModel(
        id: 3,
        name: 'Rau Củ',
        image_urls: 'assets/icons/carrot.png',
        boxColor: Color(0xff92A3FD)));
    return categories;
  }
}
