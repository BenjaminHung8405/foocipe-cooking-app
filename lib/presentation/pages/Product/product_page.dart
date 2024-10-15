import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final String productId;

  const ProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Product Page'),
      ),
    );
  }
}
