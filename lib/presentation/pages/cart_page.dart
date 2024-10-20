import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../pages/checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final storage = const FlutterSecureStorage();
  List<dynamic> cartItems = [];
  double totalPrice = 0.0;
  List<int> selectedItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartData();
  }

  Future<void> fetchCartData() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['RECIPE_SERVICE_API']}/carts/user'),
      headers: {
        'access_token': await storage.read(key: 'access_token') ?? '',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        cartItems = data;
        totalPrice = cartItems.fold(
            0, (sum, item) => sum + (item['price'] * item['quantity']));
      });
    } else {
      throw Exception('Failed to load cart data');
    }
  }

  Future<void> _deleteCartItem(int id) async {
    final response = await http.delete(
      Uri.parse('${dotenv.env['RECIPE_SERVICE_API']}/carts/delete/$id'),
      headers: {
        'access_token': await storage.read(key: 'access_token') ?? '',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      fetchCartData();
    } else {
      throw Exception('Failed to delete cart item');
    }
  }

  Future<void> _updateCartItemQuantity(int id, int newQuantity) async {
    final response = await http.put(
        Uri.parse(
            '${dotenv.env['RECIPE_SERVICE_API']}/carts/update/$id/$newQuantity'),
        headers: {
          'access_token': await storage.read(key: 'access_token') ?? '',
          'Content-Type': 'application/json',
        });
    if (response.statusCode == 200) {
      fetchCartData();
    } else {
      throw Exception('Failed to update cart item quantity');
    }
  }

  Widget _buildCartItem(String name, double price, String imageUrl,
      String category, int id, int quantity) {
    final isSelected = selectedItems.contains(id);
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedItems.add(id);
                  } else {
                    selectedItems.remove(id);
                  }
                });
              },
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 14),
                    onPressed: () async {
                      if (quantity > 1) {
                        await _updateCartItemQuantity(id, quantity - 1);
                      }
                    },
                  ),
                  Text('$quantity'),
                  IconButton(
                    icon: const Icon(Icons.add, size: 14),
                    onPressed: () async {
                      await _updateCartItemQuantity(id, quantity + 1);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Container(
              width: 100,
              height: 100,
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${price.toStringAsFixed(2)} VNĐ',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () async {
                await _deleteCartItem(id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _checkoutSelectedItems() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CheckoutPage(selectedCartIds: selectedItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return _buildCartItem(
                  item['title'],
                  item['price'],
                  item['image_urls'][0],
                  'Water, Food, Clothes',
                  item['id'],
                  item['quantity'],
                );
              },
            ),
          ),
          _buildOrderSummary(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                _checkoutSelectedItems();
              },
              child: const Text(
                'Checkout Selected Items',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    double selectedTotalPrice = 0.0;

    for (var item in cartItems) {
      if (selectedItems.contains(item['id'])) {
        selectedTotalPrice += item['price'] * item['quantity'];
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng số tiền',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text('${selectedTotalPrice.toStringAsFixed(2)} VNĐ'),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng tiền',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${(selectedTotalPrice).toStringAsFixed(2)} VNĐ',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
