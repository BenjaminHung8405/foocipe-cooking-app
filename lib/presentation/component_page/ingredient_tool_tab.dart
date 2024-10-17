import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class IngredientToolTab extends StatefulWidget {
  final FlutterSecureStorage storage;
  final List<Map<String, dynamic>> initialIngredients;
  final List<Map<String, dynamic>> initialTools;
  final Function(List<Map<String, dynamic>>) onIngredientsChanged;
  final Function(List<Map<String, dynamic>>) onToolsChanged;

  const IngredientToolTab({
    super.key,
    required this.storage,
    required this.initialIngredients,
    required this.initialTools,
    required this.onIngredientsChanged,
    required this.onToolsChanged,
  });

  @override
  _IngredientToolTabState createState() => _IngredientToolTabState();
}

class _IngredientToolTabState extends State<IngredientToolTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Nguyên liệu & Dụng cụ'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Nguyên liệu'),
            Tab(text: 'Dụng cụ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          IngredientTab(
            storage: widget.storage,
            onIngredientsChanged: widget.onIngredientsChanged,
          ),
          ToolTab(
            storage: widget.storage,
            onToolsChanged: widget.onToolsChanged,
          ),
        ],
      ),
    );
  }
}

class IngredientTab extends StatefulWidget {
  final FlutterSecureStorage storage;
  final Function(List<Map<String, dynamic>>) onIngredientsChanged;

  const IngredientTab({
    super.key,
    required this.storage,
    required this.onIngredientsChanged,
  });

  @override
  _IngredientTabState createState() => _IngredientTabState();
}

class _IngredientTabState extends State<IngredientTab> {
  List<Map<String, dynamic>> selectedIngredients = [];
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> recipes = [];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildSearchResults(),
            const SizedBox(height: 16),
            _buildSelectedIngredients(),
            const SizedBox(height: 16),
            _buildRecipes(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm nguyên liệu...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
                onChanged: (value) => searchIngredients(value),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                searchIngredients('');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (searchResults.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Kết quả tìm kiếm:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: searchResults.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final ingredient = searchResults[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    ingredient['image_urls'][0],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
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
    );
  }

  Widget _buildSelectedIngredients() {
    if (selectedIngredients.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Nguyên liệu đã chọn:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedIngredients.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final ingredient = selectedIngredients[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    ingredient['image_urls'][0],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
                title: Text(ingredient['name']),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration:
                            const InputDecoration(labelText: 'Số lượng'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          ingredient['quantity'] = double.tryParse(value) ?? 0;
                          widget.onIngredientsChanged(selectedIngredients);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(ingredient['unit']),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => removeIngredient(index),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecipes() {
    if (recipes.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Công thức phù hợp:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recipes.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    recipe['image_urls'][0],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
                title: Text(recipe['name']),
                subtitle: Text('Chuẩn bị: ${recipe['prep_time']} phút\n'
                    'Nấu: ${recipe['cook_time']} phút\n'
                    'Khẩu phần: ${recipe['servings']}\n'
                    'Độ khó: ${recipe['difficulty']}'),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> searchIngredients(String query) async {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    final accessToken = await widget.storage.read(key: 'access_token');

    if (accessToken == null) {
      print('No access token found');
      return;
    }

    final response = await http.get(
      Uri.parse('http://localhost:8081/v1/search/ingredients?name=$query'),
      headers: {
        'access_token': accessToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        searchResults = data
            .map((item) => item['_source'] as Map<String, dynamic>)
            .toList();
      });
    } else {
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
    widget.onIngredientsChanged(selectedIngredients);
    searchRecipes();
  }

  void removeIngredient(int index) {
    setState(() {
      selectedIngredients.removeAt(index);
    });
    widget.onIngredientsChanged(selectedIngredients);
    searchRecipes();
  }

  Future<void> searchRecipes() async {
    if (selectedIngredients.isEmpty) {
      setState(() => recipes = []);
      return;
    }

    final accessToken = await widget.storage.read(key: 'access_token');

    if (accessToken == null) {
      print('No access token found');
      return;
    }

    final List<int> ingredientIds =
        selectedIngredients.map((e) => e['id'] as int).toList();

    final response = await http.put(
      Uri.parse('http://localhost:8081/v1/search/recipes/ingredient'),
      headers: {
        'access_token': accessToken,
        'Content-Type': 'application/json',
      },
      body: json.encode({'ingredients': ingredientIds}),
    );

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

class ToolTab extends StatefulWidget {
  final FlutterSecureStorage storage;
  final Function(List<Map<String, dynamic>>) onToolsChanged;

  const ToolTab({
    super.key,
    required this.storage,
    required this.onToolsChanged,
  });

  @override
  _ToolTabState createState() => _ToolTabState();
}

class _ToolTabState extends State<ToolTab> {
  List<Map<String, dynamic>> selectedTools = [];
  List<Map<String, dynamic>> searchResults = [];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildSearchResults(),
            const SizedBox(height: 16),
            _buildSelectedTools(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm dụng cụ...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
                onChanged: (value) => searchTools(value),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                searchTools('');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (searchResults.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Kết quả tìm kiếm:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: searchResults.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final tool = searchResults[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    tool['image_urls'][0],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
                title: Text(tool['name']),
                subtitle: Text(tool['description']),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => addTool(tool),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTools() {
    if (selectedTools.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Dụng cụ đã chọn:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedTools.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final tool = selectedTools[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    tool['image_urls'][0],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
                title: Text(tool['name']),
                subtitle: Text(tool['description']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => removeTool(index),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> searchTools(String query) async {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    final accessToken = await widget.storage.read(key: 'access_token');

    if (accessToken == null) {
      print('No access token found');
      return;
    }

    final response = await http.get(
      Uri.parse('http://localhost:8081/v1/search/tools?name=$query'),
      headers: {
        'access_token': accessToken,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        searchResults = data
            .map((item) => item['_source'] as Map<String, dynamic>)
            .toList();
      });
    } else {
      print('Failed to search tools: ${response.statusCode}');
    }
  }

  void addTool(Map<String, dynamic> tool) {
    setState(() {
      if (!selectedTools.any((element) => element['id'] == tool['id'])) {
        selectedTools.add(tool);
      }
      searchResults = [];
      searchController.clear();
    });
    widget.onToolsChanged(selectedTools);
  }

  void removeTool(int index) {
    setState(() {
      selectedTools.removeAt(index);
    });
    widget.onToolsChanged(selectedTools);
  }
}
