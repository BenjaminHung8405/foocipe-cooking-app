import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm sản phẩm'),
      ),
      body: Column(
        children: [
          Text(
            'Thêm ảnh sản phẩm',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 94, 89, 74),
            ),
          ),
          Text(
            'Thêm ảnh để mô tả sản phẩm của bạn',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 94, 89, 74),
            ),
          ),
        ],
      ),
    );
  }
}
