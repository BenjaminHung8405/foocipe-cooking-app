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
  String difficulty = 'Dễ';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _category = 'Món chính';
  List<String> _subCategories = ['Món Việt', 'Súp'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('I. Thông tin công thức',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  _buildNameDesSection(),
                  const SizedBox(height: 24),
                  Text('II. Thông tin nấu ăn',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  _buildServingTimeSection(),
                  const SizedBox(height: 24),
                  Text('III. Thông tin loại món',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  _buildDiffCateSection(),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _createRecipe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFD8B51),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Tạo công thức',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
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
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      maxLines: maxLines,
    );
  }

  Widget _buildDescriptionField() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          child: TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
            maxLines: null,
            onChanged: (text) {
              setState(() {
                double newWidth = text.length * 8.0;
                if (newWidth > constraints.maxWidth) {
                  newWidth = constraints.maxWidth;
                }
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildNameDesSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
              'Vui lòng nhập tên công thức', Icons.title, _titleController),
          const SizedBox(height: 16),
          _buildDescriptionField(),
        ],
      ),
    );
  }

  Widget _buildServingTimeSection() {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('Số phần', servings, Icons.people),
            const Divider(),
            _buildInfoRow('Thời gian chuẩn bị', prepTime, Icons.access_time,
                unit: 'min'),
            const Divider(),
            _buildInfoRow('Thời gian nấu', cookTime, Icons.timer, unit: 'min'),
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
        const Text('Độ khó',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: ['Dễ', 'Vừa', 'Khó'].map((String value) {
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
                      borderRadius: BorderRadius.circular(10),
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

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _category,
      decoration: InputDecoration(
        labelText: 'Loại món',
        border: OutlineInputBorder(),
      ),
      items: ['Món khai vị', 'Món chính', 'Món tráng miệng', 'Đồ uống']
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
          backgroundColor: Colors.orange[100],
          onDeleted: () {
            setState(() {
              _subCategories.remove(subCategory);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildDiffCateSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDifficultySelection(),
          const SizedBox(height: 24),
          _buildCategoryDropdown(),
          const SizedBox(height: 24),
          _buildSubCategoriesChips(),
        ],
      ),
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
        "image_urls": ["https://i.ibb.co/ZmwX7K6/1.jpg"],
        "is_public": true
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
        Uri.parse('http://localhost:8081/v1/recipes'),
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
