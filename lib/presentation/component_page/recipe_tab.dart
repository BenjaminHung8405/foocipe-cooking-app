import 'package:flutter/material.dart';

class RecipeTab extends StatefulWidget {
  const RecipeTab({Key? key}) : super(key: key);

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
                  SizedBox(height: 16),
                  _buildTextField('Description', Icons.description,
                      maxLines: 3),
                  SizedBox(height: 24),
                  _buildInfoSection(),
                  SizedBox(height: 24),
                  _buildDifficultySelection(),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Next',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('Servings', servings, Icons.people),
            Divider(),
            _buildInfoRow('Prep Time', prepTime, Icons.access_time,
                unit: 'min'),
            Divider(),
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
        Icon(icon, color: Colors.orange),
        SizedBox(width: 8),
        Expanded(
            child: Text(label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
        IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () => setState(() => value > 1 ? value-- : null),
        ),
        Text('$value ${unit.isNotEmpty ? unit : ''}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          onPressed: () => setState(() => value++),
        ),
      ],
    );
  }

  Widget _buildDifficultySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Difficulty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: ['Easy', 'Medium', 'Hard'].map((String value) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () => setState(() => difficulty = value),
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        difficulty == value ? Colors.orange : Colors.grey[200],
                    foregroundColor:
                        difficulty == value ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
