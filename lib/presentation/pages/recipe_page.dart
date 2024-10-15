import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RecipePage extends StatefulWidget {
  final String recipeId;

  const RecipePage({super.key, required this.recipeId});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  Map<String, dynamic>? recipeData;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchRecipeData();
  }

  Future<void> fetchRecipeData() async {
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null) {
      print('No access token found');
      return;
    }
    final response = await http.get(
        Uri.parse(
            'https://foocipe-recipe-service.onrender.com/v1/recipe/${widget.recipeId}'),
        headers: {
          'access_token': accessToken,
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      setState(() {
        recipeData = json.decode(response.body);
      });
    } else {
      // Handle error
      print('Failed to load recipe data');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (recipeData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
      );
    }

    final recipe = recipeData!['recipeData'];
    final ingredients = recipeData!['recipeIngredientData'];
    final tools = recipeData!['recipeToolData'];
    final steps = recipeData!['stepsData'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(recipe),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRecipeHeader(recipe),
                _buildInfoSection(recipe),
                _buildDescription(recipe),
                _buildIngredientSection(ingredients),
                _buildToolSection(tools),
                _buildStepSection(steps),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(Map<String, dynamic> recipe) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              recipe['image_urls'][0],
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
        title: Text(
          recipe['name'],
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildRecipeHeader(Map<String, dynamic> recipe) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              recipe['name'],
              style: const TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.red),
            onPressed: () {
              // TODO: Implement favorite functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Map<String, dynamic> recipe) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoItem(
              Icons.access_time, '${recipe['prep_time']} min', 'Prep'),
          _buildInfoItem(Icons.whatshot, '${recipe['cook_time']} min', 'Cook'),
          _buildInfoItem(Icons.restaurant, '${recipe['servings']}', 'Servings'),
          _buildInfoItem(
              Icons.fitness_center, recipe['difficulty'], 'Difficulty'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDescription(Map<String, dynamic> recipe) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        recipe['description'],
        style: const TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }

  Widget _buildIngredientSection(List<dynamic> ingredients) {
    return _buildSection(
      'Ingredients',
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          final ingredient = ingredients[index];
          return _buildListItem(
            '${ingredient['quantity']} ${ingredient['pantry_name']}',
            Icons.check_circle_outline,
          );
        },
      ),
    );
  }

  Widget _buildToolSection(List<dynamic> tools) {
    return _buildSection(
      'Tools',
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          return _buildListItem(
            '${tool['quantity']} ${tool['pantry_name']}',
            Icons.kitchen,
          );
        },
      ),
    );
  }

  Widget _buildStepSection(List<dynamic> steps) {
    return _buildSection(
      'Steps',
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final step = steps[index];
          return _buildStepItem(step);
        },
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildListItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildStepItem(Map<String, dynamic> step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '${step['step_number']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (step['description'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      step['description'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
