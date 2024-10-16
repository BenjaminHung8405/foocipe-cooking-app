import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class IngredientTab extends StatefulWidget {
  const IngredientTab({Key? key}) : super(key: key);

  @override
  _IngredientTabState createState() => _IngredientTabState();
}

class _IngredientTabState extends State<IngredientTab> {
  List<Map<String, dynamic>> selectedIngredients = [];
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> recipes = [];
  TextEditingController searchController = TextEditingController();
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm thành phần...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => searchIngredients(value),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => searchIngredients(searchController.text),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Hiển thị kết quả tìm kiếm
            if (searchResults.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kết quả tìm kiếm:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final ingredient = searchResults[index];
                      return ListTile(
                        leading: Image.network(
                          ingredient['image_urls'][0],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        ),
                        title: Text(ingredient['name']),
                        subtitle: Text(ingredient['description']),
                        trailing: Text(ingredient['unit']),
                        onTap: () => addIngredient(ingredient),
                      );
                    },
                  ),
                ],
              ),
            SizedBox(height: 16),
            // Hiển thị thành phần đã chọn
            if (selectedIngredients.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thành phần đã chọn:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: selectedIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = selectedIngredients[index];
                      return ListTile(
                        leading: Image.network(
                          ingredient['image_urls'][0],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        ),
                        title: Text(ingredient['name']),
                        subtitle: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration:
                                    InputDecoration(labelText: 'Số lượng'),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  ingredient['quantity'] =
                                      double.tryParse(value) ?? 0;
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(ingredient['unit']),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => removeIngredient(index),
                        ),
                      );
                    },
                  ),
                ],
              ),
            SizedBox(height: 16),
            // Hiển thị danh sách công thức
            if (recipes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Công thức phù hợp:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            recipe['image_urls'][0],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                          ),
                          title: Text(recipe['name']),
                          subtitle:
                              Text('Chuẩn bị: ${recipe['prep_time']} phút\n'
                                  'Nấu: ${recipe['cook_time']} phút\n'
                                  'Khẩu phần: ${recipe['servings']}\n'
                                  'Độ khó: ${recipe['difficulty']}'),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> searchIngredients(String query) async {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null) {
      print('No access token found');
      return;
    }

    final response = await http.get(
      Uri.parse(
          'https://foocipe-recipe-service.onrender.com/v1/pantries/search?name=$query'),
      headers: {
        'access_token': accessToken,
        'Content-Type': 'application/json',
      },
    );

    print(json.decode(response.body));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        searchResults = data
            .map((item) => item['_source'] as Map<String, dynamic>)
            .toList();
      });
    } else {
      // Handle error
      print('Failed to search ingredients: ${response.statusCode}');
    }
  }

  void addIngredient(Map<String, dynamic> ingredient) {
    setState(() {
      if (!selectedIngredients
          .any((element) => element['id'] == ingredient['id'])) {
        selectedIngredients.add(ingredient);
      }
      searchResults = [];
      searchController.clear();
    });
    searchRecipes();
  }

  void removeIngredient(int index) {
    setState(() {
      selectedIngredients.removeAt(index);
    });
    searchRecipes();
  }

  Future<void> searchRecipes() async {
    if (selectedIngredients.isEmpty) {
      setState(() => recipes = []);
      return;
    }

    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null) {
      print('No access token found');
      return;
    }

    final List<int> ingredientIds =
        selectedIngredients.map((e) => e['id'] as int).toList();

    print(ingredientIds);

    final response = await http.put(
      Uri.parse(
          'https://foocipe-recipe-service.onrender.com/v1/recipes/ingredient/search'),
      headers: {
        'access_token': accessToken,
        'Content-Type': 'application/json',
      },
      body: json.encode({'ingredients': ingredientIds}),
    );

    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        recipes = List<Map<String, dynamic>>.from(data['recipes']);
      });
    } else {
      print('Failed to search recipes: ${response.statusCode}');
    }
  }
}
