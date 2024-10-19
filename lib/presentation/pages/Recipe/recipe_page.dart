import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../widgets/expandable_text.dart';
import '../../widgets/steps.dart';

class RecipePage extends StatefulWidget {
  final String recipeId;

  const RecipePage({super.key, required this.recipeId});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  Map<String, dynamic>? recipeData;
  final storage = const FlutterSecureStorage();

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
        Uri.parse('http://localhost:8081/v1/recipes/${widget.recipeId}'),
        headers: {
          'access_token': accessToken,
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      setState(() {
        recipeData = json.decode(response.body);
      });
    } else {
      print('Failed to load recipe data');
    }
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
            '${ingredient['quantity']} ${ingredient['ingredient_name']}',
            Icons.check_circle_outline,
            onTap: () => _showIngredientDetails(ingredient['ingredient_id']),
          );
        },
      ),
    );
  }

  // Thêm phương thức mới để hiển thị chi tiết ingredient
  Future<void> _showIngredientDetails(int ingredientId) async {
    final accessToken = await storage.read(key: 'access_token');
    if (accessToken == null) {
      print('No access token found');
      return;
    }

    final response = await http.get(
      Uri.parse('http://localhost:8081/v1/ingredients/$ingredientId'),
      headers: {
        'access_token': accessToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final ingredientData = json.decode(response.body);
      _showIngredientDetailDialog(ingredientData);
    } else {
      print('Failed to load ingredient data');
    }
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
            '${tool['quantity']} ${tool['tool_name']}',
            Icons.kitchen,
            onTap: () => _showToolDetails(tool['tool_id']),
          );
        },
      ),
    );
  }

  Future<void> _showToolDetails(int toolId) async {
    final accessToken = await storage.read(key: 'access_token');
    if (accessToken == null) {
      print('No access token found');
      return;
    }

    final response = await http.get(
      Uri.parse('http://localhost:8081/v1/tools/$toolId'),
      headers: {
        'access_token': accessToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final toolData = json.decode(response.body);
      _showToolDetailDialog(toolData);
    } else {
      print('Failed to load tool data');
    }
  }

  void _showIngredientDetailDialog(Map<String, dynamic> ingredientData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.orange[100],
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredientData['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Quantity: ${ingredientData['quantity']}'),
                  Text(
                      'Description: ${ingredientData['description'] ?? 'N/A'}'),
                  Text('Type: ${ingredientData['type'] ?? 'N/A'}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showToolDetailDialog(Map<String, dynamic> toolData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.orange[100],
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toolData['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Quantity: ${toolData['quantity']}'),
                Text('Description: ${toolData['description'] ?? 'N/A'}'),
                Text('Type: ${toolData['type'] ?? 'N/A'}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
      IconData icon, Color color, String label, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
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
    final ingredients = recipeData!['recipeIngredientData'] ?? [];
    final tools = recipeData!['recipeToolData'] ?? [];
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
                // _buildStepSection(steps),
                StepsWidget(steps: steps)
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
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.feedback, color: Colors.blue),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.red),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Map<String, dynamic> recipe) {
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          _buildInfoItem(Icons.access_time, '${recipe['prep_time']} min',
              'Prep', colors[0]),
          _buildInfoItem(
              Icons.whatshot, '${recipe['cook_time']} min', 'Cook', colors[1]),
          _buildInfoItem(
              Icons.restaurant, '${recipe['servings']}', 'Servings', colors[2]),
          _buildInfoItem(Icons.fitness_center, recipe['difficulty'],
              'Difficulty', colors[3]),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
      IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(Map<String, dynamic> recipe) {
    const int maxLines = 3;
    final String description = recipe['description'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ExpandableText(
            text: description,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 16, height: 1.5),
            expandText: 'Read more',
            collapseText: 'Show less',
            linkColor: Colors.blue,
          ),
        ],
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

  Widget _buildListItem(String text, IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.orange),
            const SizedBox(width: 16),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
          ],
        ),
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
