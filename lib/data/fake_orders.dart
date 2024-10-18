// lib/data/fake_orders.dart
import '../model/order.dart';

List<Order> fakeOrders = [
  Order(
      id: '1',
      customerName: 'Nguyễn Văn A',
      status: 'Chờ xác nhận',
      orderDate: DateTime.now().subtract(Duration(days: 1)),
      totalAmount: 150.0),
  Order(
      id: '2',
      customerName: 'Trần Thị B',
      status: 'Đồng ý',
      orderDate: DateTime.now().subtract(Duration(days: 2)),
      totalAmount: 200.0),
  Order(
      id: '3',
      customerName: 'Lê Văn C',
      status: 'Từ chối',
      orderDate: DateTime.now().subtract(Duration(days: 3)),
      totalAmount: 100.0),
  Order(
      id: '4',
      customerName: 'Phạm Thị D',
      status: 'Đang Giao Hàng',
      orderDate: DateTime.now().subtract(Duration(days: 4)),
      totalAmount: 250.0),
  Order(
      id: '5',
      customerName: 'Nguyễn Văn E',
      status: 'Đã Nhận Hàng',
      orderDate: DateTime.now().subtract(Duration(days: 5)),
      totalAmount: 300.0),
  Order(
      id: '6',
      customerName: 'Nguyễn Thị F',
      status: 'Chờ xác nhận',
      orderDate: DateTime.now().subtract(Duration(days: 6)),
      totalAmount: 180.0),
  Order(
      id: '7',
      customerName: 'Trần Văn G',
      status: 'Đồng ý',
      orderDate: DateTime.now().subtract(Duration(days: 7)),
      totalAmount: 220.0),
  Order(
      id: '8',
      customerName: 'Lê Thị H',
      status: 'Từ chối',
      orderDate: DateTime.now().subtract(Duration(days: 8)),
      totalAmount: 90.0),
  Order(
      id: '9',
      customerName: 'Phạm Văn I',
      status: 'Đang Giao Hàng',
      orderDate: DateTime.now().subtract(Duration(days: 9)),
      totalAmount: 270.0),
  Order(
      id: '10',
      customerName: 'Nguyễn Văn J',
      status: 'Đã Nhận Hàng',
      orderDate: DateTime.now().subtract(Duration(days: 10)),
      totalAmount: 320.0),
];
