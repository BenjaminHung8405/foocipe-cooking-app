import 'package:flutter/material.dart';
import '../../../presentation/component_page/favorite_recipe.dart';
import '../../../presentation/component_page/my_recipe.dart';

class RecipeManagementPage extends StatelessWidget {
  const RecipeManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recipe Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Favorite Recipe'),
              Tab(text: 'My Recipe'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FavoriteRecipePage(),
            MyRecipePage(),
          ],
        ),
      ),
    );
  }
}
