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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final recipe = recipeData!['recipeData'];
    final ingredients = recipeData!['recipeIngredientData'];
    final tools = recipeData!['recipeToolData'];
    final steps = recipeData!['stepsData'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                recipe['image_urls'][0],
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['name'],
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoButton(
                          Icons.access_time, '${recipe['prep_time']} MIN'),
                      _buildInfoButton(
                          Icons.whatshot, '${recipe['cook_time']} MIN'),
                      _buildInfoButton(
                          Icons.restaurant, '${recipe['servings']} SERVINGS'),
                      _buildInfoButton(
                          Icons.fitness_center, recipe['difficulty']),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    recipe['description'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Ingredients'),
                  ...ingredients.map((ingredient) => _buildListItem(
                      '${ingredient['quantity']} ${ingredient['pantry_name']}')),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Tools'),
                  ...tools.map((tool) => _buildListItem(
                      '${tool['quantity']} ${tool['pantry_name']}')),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Steps'),
                  ...steps.map((step) => _buildStepItem(step)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoButton(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.orange),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildStepItem(Map<String, dynamic> step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${step['step_number']}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                if (step['description'].isNotEmpty) Text(step['description']),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
