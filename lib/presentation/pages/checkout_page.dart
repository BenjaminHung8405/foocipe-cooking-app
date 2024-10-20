import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CheckoutPage extends StatefulWidget {
  final List<int> selectedCartIds;

  const CheckoutPage({super.key, required this.selectedCartIds});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final storage = const FlutterSecureStorage();

  bool isCardPayment = false;

  Future<List<dynamic>> _fetchCartItems() async {
    List<dynamic> items = [];
    for (var cartId in widget.selectedCartIds) {
      final response = await http.get(
        Uri.parse('${dotenv.env['RECIPE_SERVICE_API']}/carts/get/$cartId'),
        headers: {
          'access_token': await storage.read(key: 'access_token') ?? '',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        items.add(json.decode(response.body));
      } else {
        throw Exception('Failed to load cart item');
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán',
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: CustomScrollView(
        // Changed from Column to CustomScrollView

        slivers: [
          SliverToBoxAdapter(
            child: Text('Selected Cart IDs: ${widget.selectedCartIds}'),
          ),
          SliverToBoxAdapter(
            child: _buildProductList(),
          ),
          SliverToBoxAdapter(
            child: _buildPaymentMethod(),
          ),
          SliverToBoxAdapter(
            child: _buildSelectedAddress(),
          ),
          SliverToBoxAdapter(
            child: _buildTotalPrice(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return FutureBuilder<List<dynamic>>(
      future: _fetchCartItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final cartItems = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true, // Allow ListView to take only the space it needs
            physics: NeverScrollableScrollPhysics(), // Disable scrolling

            itemCount: cartItems.length,

            itemBuilder: (context, index) {
              final item = cartItems[index];

              return ListTile(
                title: Text(item['title']),
                subtitle: Text('Price: ${item['price']}'),
                leading: Image.network(item['image_urls'][0]),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      children: [
        ListTile(
          title: Text('Thanh toán sau khi nhận hàng'),
          leading: Radio<bool>(
            value: true,
            groupValue: isCardPayment,
            onChanged: (value) {
              setState(() {
                isCardPayment = value!;
              });
            },
          ),
        ),

        ListTile(
          title: Text('Thanh toán qua thẻ'),
          leading: Radio<bool>(
            value: false,
            groupValue: isCardPayment,
            onChanged: (value) {
              setState(() {
                isCardPayment = value!;
              });
            },
          ),
        ),
        // Thêm card nhập thông tin thẻ khi chọn thanh toán qua thẻ

        if (!isCardPayment) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Card ID'),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Card Name'),
                  ),
                ],
              ),
            ),
          ),
        ],

        ElevatedButton(
          onPressed: () {
            // Handle checkout for the selected payment method

            if (isCardPayment) {
              // Logic for card payment
            } else {
              // Logic for cash on delivery
            }
          },
          child: Text('Checkout'),
        ),
      ],
    );
  }

  final List<String> fakeAddresses = [
    '123 Main St, City A',
    '456 Elm St, City B',
    '789 Oak St, City C',
  ];

  Widget _buildSelectedAddress() {
    String? selectedAddress; // Biến để lưu địa chỉ đã chọn

    return Column(
      children: [
        Text('Chọn địa chỉ:'),

        // Danh sách địa chỉ

        ...fakeAddresses.map((address) {
          return ListTile(
            title: Text(address),
            leading: Radio<String>(
              value: address,
              groupValue: selectedAddress,
              onChanged: (value) {
                setState(() {
                  selectedAddress = value; // Cập nhật địa chỉ đã chọn
                });
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTotalPrice() {
    return FutureBuilder<List<dynamic>>(
      future: _fetchCartItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final cartItems = snapshot.data!;

          double shippingFee = 10000; // Đặt phí vận chuyển mặc định
          double totalPrice = cartItems.fold<double>(
                  0, (sum, item) => sum + (item['price'] as double)) +
              shippingFee; // Thêm phí vận chuyển vào tổng giá

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Subtotal: \$${(totalPrice - shippingFee).toStringAsFixed(2)}'),
                Text('Shipping Fee: \$${shippingFee.toStringAsFixed(2)}'),
                Text('Total Price: \$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }
      },
    );
  }
}
