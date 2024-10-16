import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Cart',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total 3 Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildCartItem('Banana Fruit', 'Fruit', 16.00, Colors.yellow),
                _buildCartItem('Orange Fruit', 'Fruit', 32.00, Colors.orange),
                _buildCartItem(
                    'Apple Brocoli', 'Vegetable', 25.00, Colors.green),
              ],
            ),
          ),
          _buildOrderSummary(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: Text(
                'Checkout',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
      String name, String category, double price, Color color) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        color: color,
      ),
      title: Text(name),
      subtitle: Text(category),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('\$${price.toStringAsFixed(2)}'),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {},
          ),
          Text('1'),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sub Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text('\$57.00'),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping'),
              Text('\$2.00'),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order Total',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$59.00', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
