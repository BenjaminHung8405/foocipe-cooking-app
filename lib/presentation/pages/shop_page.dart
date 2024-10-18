import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back, Khanh', style: TextStyle(fontSize: 24)),
                    Text('Time to go shopping', style: TextStyle(fontSize: 24)),
                  ],
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Grocery',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CategoryButton(label: 'All'),
                CategoryButton(label: 'Fruits'),
                CategoryButton(label: 'Vegetable'),
              ],
            ),
            SizedBox(height: 16),
            Text('Popular Product',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ProductCard(
                      name: 'Orange Fruit',
                      price: '\$25.00',
                      color: Colors.orange),
                  ProductCard(
                      name: 'Mustard Vegetable',
                      price: '\$31.00',
                      color: Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;

  const CategoryButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(label),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final Color color;

  const ProductCard(
      {required this.name, required this.price, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
