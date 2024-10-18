class Order {
  final String id;
  final String customerName;
  final String status;
  final DateTime orderDate;
  final double totalAmount;

  Order({
    required this.id,
    required this.customerName,
    required this.status,
    required this.orderDate,
    required this.totalAmount,
  });
}
