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
  final storage = FlutterSecureStorage();

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
        Uri.parse('https://foocipe-recipe-service.onrender.com/v1/list-recipe'),
        headers: {
          'access_token': accessToken,
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
                  SizedBox(
                    height: 20,
                  ),
                  _buildHeader(),
                  _searchField(),
                  SizedBox(
                    height: 30,
                  ),
                  _buildCategorySection(),
                ],
              ),
            ),
            _buildCategoryList(),
            SliverToBoxAdapter(child: const SizedBox(height: 40)),
            _buildSectionTitle('Today\'s Recipes'),
            _buildRecipeSlider(),
            SliverToBoxAdapter(child: const SizedBox(height: 40)),
            _buildSectionTitle('Recommended Recipes'),
            _buildRecommendedRecipes(),
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
      child: Text('What would you\nlike to Cook?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 35,
            fontWeight: FontWeight.w700,
          )),
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
                color: Color.fromARGB(255, 29, 40, 61),
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
              padding: EdgeInsets.only(right: 16),
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
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image(image: AssetImage(category.image_urls)),
            ),
          ),
          SizedBox(height: 8),
          Text(
            category.name,
            style: TextStyle(
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

  Widget _buildRecipeSlider() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 230,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 20 : 0, right: 16),
              child: RecipeCardV1(recipe: recipes[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecommendedRecipes() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index < recipes.length) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: RecipeCardV2(recipe: recipes[index]),
            );
          } else if (recipes.length > 5 && index == recipes.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('More'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              ),
            );
          }
          return null;
        },
        childCount: recipes.length > 5 ? recipes.length + 1 : recipes.length,
      ),
    );
  }

  Container _searchField() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF4F5F7),
          contentPadding: const EdgeInsets.all(10),
          hintText: 'Search for your recipe',
          hintStyle: const TextStyle(
              color: Color.fromARGB(255, 206, 203, 203),
              fontSize: 18,
              fontWeight: FontWeight.w400),
          prefixIcon: Padding(
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
