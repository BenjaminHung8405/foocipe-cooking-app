import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  ProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/orange.png'),
            SizedBox(height: 16),
            Text(
              'Orange Fruits',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$32.00',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                Text('4.9 (430 Review)'),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Citrus is a genus of flowering trees and shrubs in the rue family, Rutaceae...',
            ),
            SizedBox(height: 16),
            Text(
              'Nutrition',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Cal'),
                    Text('40'),
                  ],
                ),
                Column(
                  children: [
                    Text('Prot'),
                    Text('1.8g'),
                  ],
                ),
                Column(
                  children: [
                    Text('Fat'),
                    Text('0.2g'),
                  ],
                ),
                Column(
                  children: [
                    Text('Carb'),
                    Text('12g'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text('Buy Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
