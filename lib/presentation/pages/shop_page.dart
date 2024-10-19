import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../layouts/main_layout.dart';
import '../widgets/search_bar.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<dynamic> products = [];
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null) {
      print('No access token found');
      return;
    }
    final response = await http.get(
      Uri.parse('http://localhost:8081/v1/products/newest'),
      headers: {
        'access_token': accessToken ?? '',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 16.0, right: 16.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back!', style: TextStyle(fontSize: 18)),
                        Text('KhanhRom',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    CircleAvatar(
                      // Placeholder for avatar
                      radius: 20,
                      backgroundColor: Colors.grey, // Placeholder color
                    ),
                  ],
                ),
              ),
              // Searchbả
              SearchBarWidget(),
              // Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Categories',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('See All',
                      style: TextStyle(fontSize: 16, color: Colors.orange)),
                ],
              ),
              _buildCategories(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/product/${product['id']}');
                        },
                        child: ProductCard(
                          name: product['title'],
                          price: '\$${product['price'].toString()}',
                          color: Colors.orangeAccent,
                          imageUrl: product['image_urls'][0],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final Color color;
  final String imageUrl;

  const ProductCard({
    required this.name,
    required this.price,
    required this.color,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 150, // Set desired height
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Text(price),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

Widget _buildCategories() {
  return Container(
    height: 100,
    padding: EdgeInsets.only(left: 16, right: 16),
    child: ListView(
      scrollDirection: Axis.horizontal, // Change to horizontal scrolling
      children: [
        _buildCategoryTab('All'),
        _buildCategoryTab('Fruit'),
        _buildCategoryTab('Vegetable'),
        _buildCategoryTab('Meal'),
        _buildCategoryTab('Fish'),
        _buildCategoryTab('Tool'),
      ],
    ),
  );
}

Widget _buildCategoryTab(String category) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Chip(
      // Using Chip for a tab-like appearance
      label: Text(category),
    ),
  );
}
