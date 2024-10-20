import 'package:flutter/material.dart';
import '../../../presentation/component_page/favorite_recipe.dart';
import '../../../presentation/component_page/my_recipe.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class RecipeManagementPage extends StatelessWidget {
  const RecipeManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Recipe Management'),
          bottom: const TabBar(
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
