import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../layouts/main_layout.dart';
import '../widgets/search_bar.dart';
import '../widgets/product_card.dart';

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
      Uri.parse('${dotenv.env['RECIPE_SERVICE_API']}/products/newest'),
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
          return GestureDetector(
            // Thay đổi ở đây
            onTap: () {
              Navigator.pushNamed(context,
                  '/product/${product['id']}'); // Chuyển hướng đến trang sản phẩm
            },
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
      backgroundColor: bgColor,
      label: Text(
        category,
        style: TextStyle(color: textColor),
      ),
    ),
  );
}
