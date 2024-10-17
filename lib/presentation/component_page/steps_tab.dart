import 'package:flutter/material.dart';

class StepsTab extends StatefulWidget {
  final List<Map<String, dynamic>> selectedIngredients;
  final List<Map<String, dynamic>> selectedTools;

  const StepsTab({
    super.key,
    required this.selectedIngredients,
    required this.selectedTools,
  });

  @override
  _StepsTabState createState() => _StepsTabState();
}

class _StepsTabState extends State<StepsTab> {
  List<String> steps = [];
  Map<String, int> remainingIngredients = {};
  Set<String> unusedTools = {};

  @override
  void initState() {
    super.initState();
    initializeRemainingIngredients();
    initializeUnusedTools();
  }

  void initializeRemainingIngredients() {
    for (var ingredient in widget.selectedIngredients) {
      remainingIngredients[ingredient['id'].toString()] =
          ingredient['quantity'];
    }
  }

  void initializeUnusedTools() {
    unusedTools =
        widget.selectedTools.map((tool) => tool['id'].toString()).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Steps:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...steps
                  .asMap()
                  .entries
                  .map((entry) => _buildStepItem(entry.key, entry.value)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addStep,
                child: const Text('Add Step'),
              ),
              const SizedBox(height: 32),
              _buildUsageStatus(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(int index, String step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Text('${index + 1}. ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: step),
              onChanged: (value) => _updateStep(index, value),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeStep(index),
                ),
              ),
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
        const Text('Ingredient Usage:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        ...remainingIngredients.entries.map((entry) {
          final ingredient = widget.selectedIngredients
              .firstWhere((i) => i['id'].toString() == entry.key);
          return Text(
              '${ingredient['name']}: ${entry.value} ${ingredient['unit']} remaining');
        }),
        const SizedBox(height: 16),
        const Text('Unused Tools:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        ...unusedTools.map((toolId) {
          final tool = widget.selectedTools
              .firstWhere((t) => t['id'].toString() == toolId);
          return Text(tool['name']);
        }),
      ],
    );
  }

  void _addStep() {
    setState(() {
      steps.add('');
    });
  }

  void _updateStep(int index, String value) {
    setState(() {
      steps[index] = value;
      _processStep(value);
    });
  }

  void _removeStep(int index) {
    setState(() {
      steps.removeAt(index);
    });
  }

  void _processStep(String step) {
    for (var ingredient in widget.selectedIngredients) {
      final regex = RegExp(
          r'<\{ingredient_id:\s*(\d+),\s*ingredient_name:\s*"([^"]+)",\s*quantity:\s*(\d+)\}>');
      final matches = regex.allMatches(step);

      for (var match in matches) {
        final id = match.group(1)!;
        final quantity = int.parse(match.group(3)!);

        if (remainingIngredients.containsKey(id)) {
          remainingIngredients[id] = remainingIngredients[id]! - quantity;
        }
      }
    }

    for (var tool in widget.selectedTools) {
      if (step.toLowerCase().contains(tool['name'].toLowerCase())) {
        unusedTools.remove(tool['id'].toString());
      }
    }
  }
}
