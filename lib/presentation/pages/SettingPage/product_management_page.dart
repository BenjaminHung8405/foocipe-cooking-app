import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('http://localhost:8081/v1/products/seller'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        products = data.map((item) => Product.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quản lý sản phẩm")),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  child: ListTile(
                    title: Text(product.title),
                    subtitle: Text(product.description),
                    trailing: Text("\$${product.price}"),
                    leading: product.imageUrls.isNotEmpty
                        ? Image.network(product.imageUrls[0],
                            width: 50, height: 50)
                        : Container(
                            width: 50,
                            height: 50,
                            color: Colors.blue,
                          ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/setting/add/product');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Lớp Product
class Product {
  final int id;
  final int sellerId;
  final String title;
  final String description;
  final int price;
  final int stock;
  final List<String> imageUrls;
  final bool isActive;

  Product({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrls,
    required this.isActive,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      sellerId: json['seller_id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
      imageUrls: List<String>.from(json['image_urls']),
      isActive: json['is_active'],
    );
  }
}
