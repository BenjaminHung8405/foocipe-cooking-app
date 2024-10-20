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
  List<String> steps = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final savedIngredients = await storage.read(key: 'selectedIngredients');
    final savedTools = await storage.read(key: 'selectedTools');
    final savedSteps = await storage.read(key: 'steps');
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
    if (savedSteps != null) {
      setState(() {
        steps = List<String>.from(json.decode(savedSteps));
      });
    }
  }

  void _updateIngredients(List<Map<String, dynamic>> ingredients) {
    setState(() {
      selectedIngredients = ingredients;
    });
  }

  void _updateTools(List<Map<String, dynamic>> tools) {
    setState(() {
      selectedTools = tools;
    });
  }

  void _updateSteps(List<String> newSteps) {
    setState(() {
      steps = newSteps;
    });
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
          labelColor: Colors.orange,
          labelStyle: TextStyle(
              color: Color.fromARGB(255, 94, 89, 74),
              fontSize: 14,
              fontWeight: FontWeight.w600),
          indicatorColor: Colors.orange,
          indicatorWeight: 5,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Color.fromARGB(255, 94, 89, 74),
          padding: EdgeInsets.symmetric(horizontal: 20),
          unselectedLabelColor: Color.fromARGB(255, 94, 89, 74),
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
          RecipeTab(
            storage: storage,
            selectedIngredients: selectedIngredients,
            selectedTools: selectedTools,
            steps: steps,
          ),
          IngredientToolStepsTab(
            storage: storage,
          ),
        ],
      ),
    );
  }
}
