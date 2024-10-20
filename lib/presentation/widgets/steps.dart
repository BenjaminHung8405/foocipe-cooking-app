import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StepsWidget extends StatelessWidget {
  final List<dynamic> steps;

  const StepsWidget({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildSection(
      'Steps',
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final step = steps[index];
          return _buildStepItem(step, context);
        },
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  String _decodeTitle(String title) {
    final regex = RegExp(r'<\{(.*?)\}>');
    return title.replaceAllMapped(regex, (match) {
      final parts = match.group(1)!.split(', ');
      final id = parts[0].split(': ')[1];
      final name = parts[1].split(': ')[1].replaceAll('"', '');
      final quantity = parts[2].split(': ')[1];
      final unit = parts[3].split(': ')[1].replaceAll('"', '');
      return '$quantity $unit $name';
    });
  }

  Widget _buildStepItem(Map<String, dynamic> step, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${step['step_number']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClickableTitle(step['title'], context),
                if (step['description'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      step['description'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableTitle(String title, BuildContext context) {
    final regex = RegExp(r'<\{(.*?)\}>');
    final matches = regex.allMatches(title);
    String decodedTitle = title;

    for (var match in matches) {
      final parts = match.group(1)!.split(', ');
      final id = parts[0].split(': ')[1];
      final name = parts[1].split(': ')[1].replaceAll('"', '');
      final quantity = parts[2].split(': ')[1];
      final unit = parts[3].split(': ')[1].replaceAll('"', '');

      // Replace the placeholder with a clickable text
      decodedTitle = decodedTitle.replaceFirst(
        match.group(0)!,
        '$quantity $unit $name',
      );
    }

    return RichText(
      text: TextSpan(
        children: _buildTextSpans(decodedTitle, context),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String title, BuildContext context) {
    final regex = RegExp(r'(\d+ \w+ \w+|\w+)');
    final matches = regex.allMatches(title);
    List<TextSpan> spans = [];

    int lastMatchEnd = 0;

    for (var match in matches) {
      if (lastMatchEnd < match.start) {
        spans.add(TextSpan(text: title.substring(lastMatchEnd, match.start)));
      }

      String matchedText = match.group(0)!;
      if (matchedText.contains(' ')) {
        // If the matched text contains a space, it could be a tool or ingredient
        final isTool = matchedText.contains('Dao'); // Check for tool name
        final isIngredient =
            matchedText.contains('Thịt bò'); // Check for ingredient name

        spans.add(TextSpan(
          text: matchedText,
          style: const TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (isTool) {
                _showToolDetails(4, context); // Replace with actual tool ID
              } else if (isIngredient) {
                _showIngredientDetails(
                    5, context); // Replace with actual ingredient ID
              }
            },
        ));
      } else {
        spans.add(TextSpan(text: matchedText));
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < title.length) {
      spans.add(TextSpan(text: title.substring(lastMatchEnd)));
    }

    return spans;
  }

  Future<void> _showIngredientDetails(
      int ingredientId, BuildContext context) async {
    final response = await http.get(
      Uri.parse('http://localhost:8081/v1/ingredients/$ingredientId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final ingredientData = json.decode(response.body);
      _showDetailDialog(ingredientData, context);
    } else {
      print('Failed to load ingredient data');
    }
  }

  Future<void> _showToolDetails(int toolId, BuildContext context) async {
    final response = await http.get(
      Uri.parse('http://localhost:8081/v1/tools/$toolId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final toolData = json.decode(response.body);
      _showDetailDialog(toolData, context);
    } else {
      print('Failed to load tool data');
    }
  }

  void _showDetailDialog(Map<String, dynamic> data, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.orange[100],
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Category: ${data['category']}'),
                  Text('Sub-categories: ${data['sub_categories'].join(', ')}'),
                  Text('Description: ${data['description'] ?? 'N/A'}'),
                  Text('Unit: ${data['unit'] ?? 'N/A'}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
