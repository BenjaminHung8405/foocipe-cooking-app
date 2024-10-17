import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../presentation/component_page/recipe_tab.dart';
import '../../../presentation/component_page/ingredient_tool_steps_tab.dart';
import 'dart:convert';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> selectedIngredients = [];
  List<Map<String, dynamic>> selectedTools = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final savedIngredients = await storage.read(key: 'selectedIngredients');
    final savedTools = await storage.read(key: 'selectedTools');
    if (savedIngredients != null) {
      setState(() {
        selectedIngredients =
            List<Map<String, dynamic>>.from(json.decode(savedIngredients));
      });
    }
    if (savedTools != null) {
      setState(() {
        selectedTools =
            List<Map<String, dynamic>>.from(json.decode(savedTools));
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Recipe'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu),
                  SizedBox(width: 8),
                  Text('Recipe'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_basket),
                  SizedBox(width: 8),
                  Text('Ingredient & Tool'),
                ],
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const RecipeTab(),
          IngredientToolStepsTab(storage: storage),
        ],
      ),
    );
  }
}
