import 'package:flutter/material.dart';

class RecipeTab extends StatefulWidget {
  const RecipeTab({super.key});

  @override
  _RecipeTabState createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab> {
  int servings = 1;
  int prepTime = 20;
  int cookTime = 30;
  String difficulty = 'Easy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Recipe Title', Icons.title),
                  const SizedBox(height: 16),
                  _buildTextField('Description', Icons.description,
                      maxLines: 3),
                  const SizedBox(height: 24),
                  _buildInfoSection(),
                  const SizedBox(height: 24),
                  _buildDifficultySelection(),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, {int maxLines = 1}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      maxLines: maxLines,
    );
  }

  Widget _buildInfoSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('Servings', servings, Icons.people),
            const Divider(),
            _buildInfoRow('Prep Time', prepTime, Icons.access_time,
                unit: 'min'),
            const Divider(),
            _buildInfoRow('Cook Time', cookTime, Icons.timer, unit: 'min'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, int value, IconData icon,
      {String unit = ''}) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () => setState(() => value > 1 ? value-- : null),
        ),
        Text('$value ${unit.isNotEmpty ? unit : ''}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => setState(() => value++),
        ),
      ],
    );
  }

  Widget _buildDifficultySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Difficulty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: ['Easy', 'Medium', 'Hard'].map((String value) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () => setState(() => difficulty = value),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: difficulty == value
                        ? Theme.of(context).primaryColor
                        : Colors.grey[200],
                    foregroundColor:
                        difficulty == value ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
}
