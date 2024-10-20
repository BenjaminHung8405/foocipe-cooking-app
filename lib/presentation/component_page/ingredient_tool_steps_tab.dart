import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IngredientToolStepsTab extends StatefulWidget {
  final FlutterSecureStorage storage;

  const IngredientToolStepsTab({
    Key? key,
    required this.storage,
  }) : super(key: key);

  @override
  _IngredientToolStepsTabState createState() => _IngredientToolStepsTabState();
}

class _IngredientToolStepsTabState extends State<IngredientToolStepsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> selectedIngredients = [];
  List<Map<String, dynamic>> selectedTools = [];
  List<String> steps = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final savedIngredients =
        await widget.storage.read(key: 'selectedIngredients');
    final savedTools = await widget.storage.read(key: 'selectedTools');
    final savedSteps = await widget.storage.read(key: 'steps');

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

  void _saveData() {
    widget.storage.write(
        key: 'selectedIngredients', value: json.encode(selectedIngredients));
    widget.storage
        .write(key: 'selectedTools', value: json.encode(selectedTools));
    widget.storage.write(key: 'steps', value: json.encode(steps));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.food_bank), text: 'Ingredients'),
              Tab(icon: Icon(Icons.build), text: 'Tools'),
              Tab(icon: Icon(Icons.list), text: 'Steps'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                IngredientTab(
                  selectedIngredients: selectedIngredients,
                  storage: widget.storage,
                  onIngredientsChanged: (ingredients) {
                    setState(() {
                      selectedIngredients = ingredients;
                    });
                    _saveData();
                  },
                ),
                ToolTab(
                  selectedTools: selectedTools,
                  storage: widget.storage,
                  onToolsChanged: (tools) {
                    setState(() {
                      selectedTools = tools;
                    });
                    _saveData();
                  },
                ),
                StepsTab(
                  steps: steps,
                  selectedIngredients: selectedIngredients,
                  selectedTools: selectedTools,
                  onStepsChanged: (newSteps) {
                    setState(() {
                      steps = newSteps;
                    });
                    _saveData();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IngredientTab extends StatefulWidget {
  final List<Map<String, dynamic>> selectedIngredients;
  final FlutterSecureStorage storage;
  final Function(List<Map<String, dynamic>>) onIngredientsChanged;

  const IngredientTab({
    Key? key,
    required this.selectedIngredients,
    required this.storage,
    required this.onIngredientsChanged,
  }) : super(key: key);

  @override
  _IngredientTabState createState() => _IngredientTabState();
}

class _IngredientTabState extends State<IngredientTab> {
  List<Map<String, dynamic>> searchResults = [];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSearchBar(),
          SizedBox(height: 16),
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: searchResults.isEmpty
                  ? _buildSelectedIngredients()
                  : _buildSearchIngredientsResults(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm nguyên liệu...',
        hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 94, 89, 74).withOpacity(0.3)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 94, 89, 74),
            ),
            borderRadius: BorderRadius.circular(18)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 94, 89, 74).withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(18)),
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () => searchIngredients(searchController.text),
        ),
      ),
      onSubmitted: (value) => searchIngredients(value),
    );
  }

  Widget _buildSearchIngredientsResults() {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final ingredient = searchResults[index];
        return GestureDetector(
          onTap: () => addIngredient(ingredient),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                ingredient['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(ingredient['description']),
              trailing: IconButton(
                icon: Icon(Icons.add, color: Colors.green),
                onPressed: () => addIngredient(ingredient),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedIngredients() {
    return ListView.builder(
      itemCount: widget.selectedIngredients.length,
      itemBuilder: (context, index) {
        final ingredient = widget.selectedIngredients[index];
        return GestureDetector(
          onTap: () => updateIngredientQuantity(index, 1),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                ingredient['name'],
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              subtitle: Text(
                'Số lượng: ${ingredient['quantity']} ${ingredient['unit']}',
                style: TextStyle(color: Colors.black54),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, color: Colors.red),
                    onPressed: () => updateIngredientQuantity(index, -1),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.green),
                    onPressed: () => updateIngredientQuantity(index, 1),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => removeIngredient(index),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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

    try {
      final response = await http.get(
        Uri.parse(
            '${dotenv.env['RECIPE_SERVICE_API']}/search/ingredients?name=$query'),
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
        throw Exception('Failed to search ingredients: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching ingredients: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to search ingredients. Please try again.')),
      );
    }
  }

  void addIngredient(Map<String, dynamic> ingredient) {
    setState(() {
      final existingIndex = widget.selectedIngredients
          .indexWhere((element) => element['id'] == ingredient['id']);
      if (existingIndex == -1) {
        widget.selectedIngredients.add({...ingredient, 'quantity': 1});
      } else {
        updateIngredientQuantity(existingIndex, 1);
      }
      searchResults = [];
      searchController.clear();
    });
    widget.onIngredientsChanged(widget.selectedIngredients);
  }

  void updateIngredientQuantity(int index, int change) {
    setState(() {
      final newQuantity =
          (widget.selectedIngredients[index]['quantity'] as int) + change;
      if (newQuantity > 0) {
        widget.selectedIngredients[index]['quantity'] = newQuantity;
      } else if (newQuantity <= 0) {
        widget.selectedIngredients.removeAt(index);
      }
    });
    widget.onIngredientsChanged(widget.selectedIngredients);
  }

  void removeIngredient(int index) {
    setState(() {
      widget.selectedIngredients.removeAt(index);
    });
    widget.onIngredientsChanged(widget.selectedIngredients);
  }
}

class ToolTab extends StatefulWidget {
  final List<Map<String, dynamic>> selectedTools;
  final FlutterSecureStorage storage;
  final Function(List<Map<String, dynamic>>) onToolsChanged;

  const ToolTab({
    Key? key,
    required this.selectedTools,
    required this.storage,
    required this.onToolsChanged,
  }) : super(key: key);

  @override
  _ToolTabState createState() => _ToolTabState();
}

class _ToolTabState extends State<ToolTab> {
  List<Map<String, dynamic>> searchResults = [];
  TextEditingController searchController = TextEditingController();

  void addToolWithQuantity(Map<String, dynamic> tool, int quantity) {
    setState(() {
      final existingIndex = widget.selectedTools
          .indexWhere((element) => element['id'] == tool['id']);
      if (existingIndex == -1) {
        widget.selectedTools.add({...tool, 'quantity': quantity});
      } else {
        widget.selectedTools[existingIndex]['quantity'] += quantity;
      }
      searchResults = [];
      searchController.clear();
    });
    widget.onToolsChanged(widget.selectedTools);
  }

  // Tool tab
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSearchBar(),
          SizedBox(height: 16),
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: searchResults.isEmpty
                  ? _buildSelectedTools()
                  : _buildSearchToolsResults(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 94, 89, 74),
            ),
            borderRadius: BorderRadius.circular(18)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 94, 89, 74).withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(18)),
        hintText: 'Tìm kiếm dụng cụ...',
        hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 94, 89, 74).withOpacity(0.3)),
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () => searchTools(searchController.text),
        ),
      ),
      onSubmitted: (value) => searchTools(value),
    );
  }

  Widget _buildSearchToolsResults() {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final tool = searchResults[index];
        TextEditingController quantityController = TextEditingController();
        return GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                tool['name'],
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              subtitle: Text(tool['description']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Qty'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.green),
                    onPressed: () {
                      final quantity =
                          int.tryParse(quantityController.text) ?? 1;
                      addToolWithQuantity(tool, quantity);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedTools() {
    return ListView.builder(
      itemCount: widget.selectedTools.length,
      itemBuilder: (context, index) {
        final tool = widget.selectedTools[index];
        return GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                tool['name'],
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              subtitle: Text(tool['description']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Qty: ${tool['quantity']}',
                      style: TextStyle(color: Colors.black54)),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => removeTool(index),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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

    try {
      final response = await http.get(
        Uri.parse(
            '${dotenv.env['RECIPE_SERVICE_API']}/search/tools?name=$query'),
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
        throw Exception('Failed to search tools: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching tools: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to search tools. Please try again.')),
      );
    }
  }

  void removeTool(int index) {
    setState(() {
      widget.selectedTools.removeAt(index);
    });
    widget.onToolsChanged(widget.selectedTools);
  }
}

class StepsTab extends StatefulWidget {
  final List<String> steps;
  final List<Map<String, dynamic>> selectedIngredients;
  final List<Map<String, dynamic>> selectedTools;
  final Function(List<String>) onStepsChanged;

  const StepsTab({
    Key? key,
    required this.steps,
    required this.selectedIngredients,
    required this.selectedTools,
    required this.onStepsChanged,
  }) : super(key: key);

  @override
  _StepsTabState createState() => _StepsTabState();
}

class _StepsTabState extends State<StepsTab> {
  Map<String, int> remainingIngredients = {};
  Map<String, int> usedIngredients = {};
  Set<String> unusedTools = {};
  List<String> steps = [];
  List<TextEditingController> stepControllers = [];

  @override
  void initState() {
    super.initState();
    initializeRemainingIngredients();
    initializeUnusedTools();
    steps = List.from(widget.steps);
    stepControllers = steps
        .map((step) => TextEditingController(text: _formatStepForDisplay(step)))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void initializeRemainingIngredients() {
    remainingIngredients = {
      for (var ingredient in widget.selectedIngredients)
        ingredient['id'].toString(): ingredient['quantity']
    };
  }

  void initializeUnusedTools() {
    unusedTools =
        widget.selectedTools.map((tool) => tool['id'].toString()).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Steps:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ...steps
                .asMap()
                .entries
                .map((entry) => _buildStepItem(entry.key, entry.value)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addStep,
              child: Text('Add Step'),
            ),
            SizedBox(height: 32),
            _buildUsageStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(int index, String step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Text('${index + 1}. ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: TextField(
              controller: stepControllers[index],
              onChanged: (value) => _updateStep(index, value),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removeStep(index),
                ),
              ),
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ingredient Usage:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        ...remainingIngredients.entries.map((entry) {
          final ingredient = widget.selectedIngredients
              .firstWhere((i) => i['id'].toString() == entry.key);
          final isUsed = usedIngredients.containsKey(entry.key);
          final isFullyUsed = entry.value == 0;
          return ElevatedButton(
            onPressed: () => _showIngredientDialog(ingredient, entry.value),
            child: Text(
                '${ingredient['name']}: ${entry.value} ${ingredient['unit']} remaining'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isUsed
                  ? (isFullyUsed ? Colors.green : Colors.orange)
                  : Colors.red,
            ),
          );
        }),
        SizedBox(height: 16),
        Text('Unused Tools:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...unusedTools.map((toolId) {
          final tool = widget.selectedTools
              .firstWhere((t) => t['id'].toString() == toolId);
          return ElevatedButton(
            onPressed: () => _addToolToStep(tool),
            child: Text(tool['name']),
          );
        }),
      ],
    );
  }

  void _showIngredientDialog(
      Map<String, dynamic> ingredient, int remainingQuantity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int quantity = 0;
        return AlertDialog(
          title: Text('Use ${ingredient['name']}'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Quantity to use (${ingredient['unit']})'),
            onChanged: (value) {
              quantity = int.tryParse(value) ?? 0;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (quantity > 0 && quantity <= remainingQuantity) {
                  _addIngredientToStep(ingredient, quantity);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid quantity')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addIngredientToStep(Map<String, dynamic> ingredient, int quantity) {
    final currentStepIndex = steps.length - 1;
    final ingredientText =
        '<{ingredient_id: ${ingredient['id']}, ingredient_name: "${ingredient['name']}", quantity: $quantity}>';
    final displayText = '$quantity${ingredient['unit']} ${ingredient['name']}';

    setState(() {
      if (currentStepIndex >= 0) {
        steps[currentStepIndex] += ' $ingredientText';
        stepControllers[currentStepIndex].text += ' $displayText';
      } else {
        steps.add(ingredientText);
        stepControllers.add(TextEditingController(text: displayText));
      }
    });
    widget.onStepsChanged(steps);
    _processAllSteps();
  }

  void _addToolToStep(Map<String, dynamic> tool) {
    final currentStepIndex = steps.length - 1;
    setState(() {
      if (currentStepIndex >= 0) {
        stepControllers[currentStepIndex].text += ' ${tool['name']}';
        steps[currentStepIndex] =
            _formatStepForStorage(stepControllers[currentStepIndex].text);
      } else {
        steps.add(tool['name']);
        stepControllers.add(TextEditingController(text: tool['name']));
      }
    });
    widget.onStepsChanged(steps);
    _processAllSteps();
  }

  void _addStep() {
    setState(() {
      steps.add('');
      stepControllers.add(TextEditingController());
    });
    widget.onStepsChanged(steps);
  }

  void _updateStep(int index, String value) {
    setState(() {
      steps[index] = _formatStepForStorage(value);
    });
    widget.onStepsChanged(steps);
    _processAllSteps();
  }

  void _removeStep(int index) {
    setState(() {
      steps.removeAt(index);
      stepControllers[index].dispose();
      stepControllers.removeAt(index);
    });
    widget.onStepsChanged(steps);
    _processAllSteps();
  }

  void _processAllSteps() {
    initializeRemainingIngredients();
    initializeUnusedTools();
    usedIngredients.clear();

    for (var step in steps) {
      _processStep(step);
    }

    setState(() {});
  }

  void _processStep(String step) {
    final ingredientRegex = RegExp(
        r'<\{ingredient_id:\s*(\d+),\s*ingredient_name:\s*"([^"]+)",\s*quantity:\s*(\d+)\}>');
    final matches = ingredientRegex.allMatches(step);

    for (var match in matches) {
      final id = match.group(1)!;
      final quantity = int.parse(match.group(3)!);

      if (remainingIngredients.containsKey(id)) {
        remainingIngredients[id] = (remainingIngredients[id]! - quantity)
            .clamp(0, double.infinity)
            .toInt();
        usedIngredients[id] = (usedIngredients[id] ?? 0) + quantity;
      }
    }

    for (var tool in widget.selectedTools) {
      if (step.toLowerCase().contains(tool['name'].toLowerCase())) {
        unusedTools.remove(tool['id'].toString());
      }
    }
  }

  String _formatStepForDisplay(String step) {
    final ingredientRegex = RegExp(
        r'<\{ingredient_id:\s*(\d+),\s*ingredient_name:\s*"([^"]+)",\s*quantity:\s*(\d+)\}>');
    return step.replaceAllMapped(ingredientRegex, (match) {
      final ingredientName = match.group(2)!;
      final quantity = match.group(3)!;
      final ingredient = widget.selectedIngredients
          .firstWhere((i) => i['name'] == ingredientName);
      return '$quantity${ingredient['unit']} $ingredientName';
    });
  }

  String _formatStepForStorage(String step) {
    final displayRegex = RegExp(r'(\d+)(\w+)\s+([^,]+)');
    return step.replaceAllMapped(displayRegex, (match) {
      final quantity = match.group(1)!;
      final ingredientName = match.group(3)!;
      final ingredient = widget.selectedIngredients
          .firstWhere((i) => i['name'] == ingredientName);
      return '<{ingredient_id: ${ingredient['id']}, ingredient_name: "$ingredientName", quantity: $quantity}>';
    });
  }
}
