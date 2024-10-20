import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyRecipePage extends StatefulWidget {
  const MyRecipePage({super.key});

  @override
  State<MyRecipePage> createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<MyRecipePage> {
  final storage = const FlutterSecureStorage();

  Future<List<Recipe>> fetchRecipes() async {
    final accessToken = await storage.read(key: 'access_token');

    final response = await http.get(
      Uri.parse('http://localhost:8081/v1/recipes/my'),
      headers: {
        'access_token': accessToken ?? '',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['recipes'] as List)
          .map((recipe) => Recipe.fromJson(recipe))
          .toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Recipe>>(
        future: fetchRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.orange,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(recipes[index].name),
                  subtitle: Text(
                      'Cook time: ${recipes[index].cookTime} min, Difficulty: ${recipes[index].difficulty}'),
                  onTap: () {
                    // Chuyển hướng đến trang chi tiết của công thức
                    Navigator.pushNamed(
                        context, '/recipe/${recipes[index].id}');
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/recipe/add');
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.orange),
    );
  }
}

class Recipe {
  final int cookTime;
  final String difficulty;
  final int id;
  final List<String> imageUrls;
  final String name;

  Recipe(
      {required this.cookTime,
      required this.difficulty,
      required this.id,
      required this.imageUrls,
      required this.name});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      cookTime: json['cook_time'],
      difficulty: json['difficulty'],
      id: json['id'],
      imageUrls: List<String>.from(json['image_urls']),
      name: json['name'],
    );
  }
}
