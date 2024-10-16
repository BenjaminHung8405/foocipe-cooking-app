import 'package:flutter/material.dart';
import 'package:foocipe_cooking_app/model/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/recipe_card.dart';
import '../layouts/main_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];
  List<Map<String, dynamic>> recipes = [];
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _getInitialInfo();
    _fetchRecipes();
  }

  void _getInitialInfo() {
    categories = CategoryModel.getCategories();
  }

  Future<void> _fetchRecipes() async {
    try {
      final accessToken = await storage.read(key: 'access_token');

      if (accessToken == null) {
        print('No access token found');
        return;
      }

      final response = await http.get(
        Uri.parse('http://localhost:8081/v1/recipes/newest'),
        headers: {
          'access_token': accessToken ?? '',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          recipes = List<Map<String, dynamic>>.from(data['recipes']);
        });
      } else {
        print('Failed to fetch recipes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        child: SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  _buildHeader(),
                  _searchField(),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildCategorySection(),
                ],
              ),
            ),
            _buildCategoryList(),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
            _buildSectionTitle('Newest Recipes'),
            _buildNewestRecipeSlider(),
          ],
        ),
      ),
    ));
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
      ),
      child: const Text(
        'What would you\nlike to Cook?',
        style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            height: 1),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Category',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color.fromARGB(255, 29, 40, 61),
                fontWeight: FontWeight.w700,
                fontSize: 25),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'See all',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          itemCount: categories.length,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _buildCategoryItem(categories[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryItem(CategoryModel category) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: category.boxColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image(image: AssetImage(category.image_urls)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 12),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w700, fontSize: 25),
        ),
      ),
    );
  }

  Widget _buildNewestRecipeSlider() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 230,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 20 : 0, right: 16),
              // Ensure to pass the correct image URL or a placeholder if empty
              child: RecipeCardV1(
                recipe: {
                  ...recipes[index],
                  'image_urls': recipes[index]['image_urls'].isNotEmpty
                      ? recipes[index]['image_urls']
                      : [
                          'https://via.placeholder.com/150'
                        ], // Placeholder image
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Container _searchField() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF4F5F7),
          contentPadding: const EdgeInsets.all(10),
          hintText: 'Search for your recipe',
          hintStyle: const TextStyle(
              color: Color.fromARGB(255, 206, 203, 203),
              fontSize: 18,
              fontWeight: FontWeight.w400),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 15, right: 10),
            child: Icon(
              Icons.search_rounded,
              size: 30,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
