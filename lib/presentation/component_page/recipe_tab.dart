import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeTab extends StatefulWidget {
  final FlutterSecureStorage storage;
  final List<Map<String, dynamic>> selectedIngredients;
  final List<Map<String, dynamic>> selectedTools;
  final List<String> steps;

  const RecipeTab({
    Key? key,
    required this.storage,
    required this.selectedIngredients,
    required this.selectedTools,
    required this.steps,
  }) : super(key: key);

  @override
  _RecipeTabState createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab> {
  int servings = 1;
  int prepTime = 20;
  int cookTime = 30;
  String difficulty = 'Easy';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isPublic = true;
  String _category = 'Main Course';
  List<String> _subCategories = ['Vietnamese', 'Soup'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                      'Recipe Title', Icons.title, _titleController),
                  const SizedBox(height: 16),
                  _buildTextField(
                      'Description', Icons.description, _descriptionController,
                      maxLines: 3),
                  const SizedBox(height: 24),
                  _buildInfoSection(),
                  const SizedBox(height: 24),
                  _buildDifficultySelection(),
                  const SizedBox(height: 24),
                  _buildPublicToggle(),
                  const SizedBox(height: 24),
                  _buildCategoryDropdown(),
                  const SizedBox(height: 24),
                  _buildSubCategoriesChips(),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _createRecipe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFD8B51),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Create Recipe'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String hint, IconData icon, TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      maxLines: maxLines,
    );
  }

  Widget _buildInfoSection() {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('Servings', servings, Icons.people),
            const Divider(),
            _buildInfoRow('Prep Time', prepTime, Icons.access_time,
                unit: 'min'),
            const Divider(),
            _buildInfoRow('Cook Time', cookTime, Icons.timer, unit: 'min'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, int value, IconData icon,
      {String unit = ''}) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFFD8B51)),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 94, 89, 74),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          height: 40,
          width: 105,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => setState(() {
                  if (value > 1) {
                    switch (label) {
                      case 'Servings':
                        servings--;
                        break;
                      case 'Prep Time':
                        prepTime--;
                        break;
                      case 'Cook Time':
                        cookTime--;
                        break;
                    }
                  }
                }),
              ),
              Text('$value',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => setState(() {
                  switch (label) {
                    case 'Servings':
                      servings++;
                      break;
                    case 'Prep Time':
                      prepTime++;
                      break;
                    case 'Cook Time':
                      cookTime++;
                      break;
                  }
                }),
              ),
            ],
          ),
        ),
        Expanded(
          child: Text('${unit.isNotEmpty ? unit : ''}',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildDifficultySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Difficulty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: ['Easy', 'Medium', 'Hard'].map((String value) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () => setState(() => difficulty = value),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: difficulty == value
                        ? Color(0xFFFD8B51)
                        : Colors.grey[200],
                    foregroundColor:
                        difficulty == value ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(value),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPublicToggle() {
    return Row(
      children: [
        Text('Public Recipe'),
        Switch(
          value: _isPublic,
          onChanged: (value) {
            setState(() {
              _isPublic = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _category,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: ['Appetizer', 'Main Course', 'Dessert', 'Beverage']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _category = newValue!;
        });
      },
    );
  }

  Widget _buildSubCategoriesChips() {
    return Wrap(
      spacing: 8.0,
      children: _subCategories.map((String subCategory) {
        return Chip(
          label: Text(subCategory),
          onDeleted: () {
            setState(() {
              _subCategories.remove(subCategory);
            });
          },
        );
      }).toList(),
    );
  }

  Future<void> _createRecipe() async {
    final accessToken = await widget.storage.read(key: 'access_token');

    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No access token found')),
      );
      return;
    }

    final recipeData = {
      "recipeData": {
        "name": _titleController.text,
        "description": _descriptionController.text,
        "difficulty": difficulty,
        "prep_time": prepTime,
        "cook_time": cookTime,
        "servings": servings,
        "category": _category,
        "sub_categories": _subCategories,
        "image_urls": [], // Add image URLs if available
        "is_public": _isPublic
      },
      "recipeIngredientData": widget.selectedIngredients.map((ingredient) {
        return {
          "ingredient_id": ingredient['id'],
          "quantity": ingredient['quantity']
        };
      }).toList(),
      "recipeToolData": widget.selectedTools.map((tool) {
        return {"tool_id": tool['id'], "quantity": 1};
      }).toList(),
      "stepsData": widget.steps.asMap().entries.map((entry) {
        return {
          "step_number": entry.key + 1,
          "title": entry.value,
          "description": ""
        };
      }).toList(),
    };

    try {
      final response = await http.post(
        Uri.parse('https://foocipe-recipe-service.onrender.com/v1/recipes'),
        headers: {
          'access_token': accessToken,
          'Content-Type': 'application/json',
        },
        body: json.encode(recipeData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recipe created successfully')),
        );
        // Optionally, navigate to a different screen or clear the form
      } else {
        throw Exception('Failed to create recipe: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating recipe: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create recipe. Please try again.')),
      );
    }
  }
}
