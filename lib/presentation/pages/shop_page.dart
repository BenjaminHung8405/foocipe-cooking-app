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
        print(products);
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
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHeader(),
                    SearchBarWidget(),
                    _buildCategories(),
                    _buildProductGrid(),
                    _buildProductSlider()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back!', style: TextStyle(fontSize: 18)),
              Text('KhanhRom',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey, // Placeholder color
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            title: product['title'],
            price: product['price'],
            color: Colors.white,
            imageUrl: product['image_urls'][0],
          );
        },
      ),
    );
  }

  Widget _buildProductSlider() {
    return Container(
      height: 200, // Set a height for the slider
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductCard(
              title: product['title'],
              price: product['price'],
              color: Colors.white,
              imageUrl: product['image_urls'][0],
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final double price;
  final Color color;
  final String imageUrl;

  const ProductCard({
    required this.title,
    required this.price,
    required this.color,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 4,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(imageUrl, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14, color: Colors.green),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('+'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.only(top: 4, bottom: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCategories() {
  return Container(
    height: 100,
    padding: EdgeInsets.only(),
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        _buildCategoryTab('All', Colors.orange, Colors.white),
        _buildCategoryTab('Fruit', Colors.grey.shade100, Colors.black),
        _buildCategoryTab('Vegetable', Colors.grey.shade100, Colors.black),
        _buildCategoryTab('Meal', Colors.grey.shade100, Colors.black),
        _buildCategoryTab('Fish', Colors.grey.shade100, Colors.black),
        _buildCategoryTab('Tool', Colors.grey.shade100, Colors.black),
      ],
    ),
  );
}

Widget _buildCategoryTab(String category, Color bgColor, Color textColor) {
  return Padding(
    padding: const EdgeInsets.only(right: 8),
    child: Chip(
      backgroundColor: bgColor, // Set background color
      label: Text(
        category,
        style: TextStyle(color: textColor), // Set text color
      ),
    ),
  );
}
