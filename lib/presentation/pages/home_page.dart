import 'package:flutter/material.dart';
import 'package:foocipe_cooking_app/model/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/recipe_card.dart';

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
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  _searchField(),
                  _buildCategorySection(),
                ],
              ),
            ),
            _buildCategoryList(),
            SliverToBoxAdapter(child: const SizedBox(height: 20)),
            _buildSectionTitle('Today\'s Recipes'),
            _buildRecipeSlider(),
            SliverToBoxAdapter(child: const SizedBox(height: 30)),
            _buildSectionTitle('Recommended Recipes'),
            _buildRecommendedRecipes(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'What would you like to Cook?',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
                  color: Color(0xFF3E5481),
                  fontWeight: FontWeight.w700,
                ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'See all',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
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
        color: category.boxColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: category.boxColor.withOpacity(0.3),
          width: 1,
        ),
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
                  color: Colors.grey.withOpacity(0.1),
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
              color: Color(0xFF3E5481),
              fontWeight: FontWeight.w600,
              fontSize: 14,
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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
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
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
