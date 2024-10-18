// lib/presentation/pages/SettingPage/order_management_page.dart
import 'package:flutter/material.dart';
import '../../../data/fake_orders.dart';
import '../../../model/order.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  State<OrderManagementPage> createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  List<Order> orders = fakeOrders;
  String filter = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Đơn Đặt Hàng'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: OrderSearchDelegate(orders));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          Order order = orders[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(order.customerName),
              subtitle: Text(
                  'Trạng thái: ${order.status} - Tổng tiền: ${order.totalAmount}'),
              trailing:
                  Text(order.orderDate.toLocal().toString().split(' ')[0]),
              onTap: () {
                // Xử lý khi nhấn vào đơn hàng
                _showOrderDetails(order);
              },
            ),
          );
        },
      ),
    );
  }

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chi tiết đơn hàng'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Khách hàng: ${order.customerName}'),
              Text('Trạng thái: ${order.status}'),
              Text(
                  'Ngày đặt: ${order.orderDate.toLocal().toString().split(' ')[0]}'),
              Text('Tổng tiền: ${order.totalAmount}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}

class OrderSearchDelegate extends SearchDelegate<Order?> {
  final List<Order> orders;

  OrderSearchDelegate(this.orders);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = orders
        .where((order) =>
            order.customerName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        Order order = results[index];
        return ListTile(
          title: Text(order.customerName),
          subtitle: Text(
              'Trạng thái: ${order.status} - Tổng tiền: ${order.totalAmount}'),
          onTap: () {
            close(context, order);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = orders
        .where((order) =>
            order.customerName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        Order order = suggestions[index];
        return ListTile(
          title: Text(order.customerName),
          subtitle: Text(
              'Trạng thái: ${order.status} - Tổng tiền: ${order.totalAmount}'),
          onTap: () {
            query = order.customerName;
            showResults(context);
          },
        );
      },
    );
  }
}
