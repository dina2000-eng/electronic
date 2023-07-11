// OrderItem model

class OrderItem {
  final String product;
  final String quantity;

  OrderItem({
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'product': product,
        'quantity': quantity,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      product: json['product'],
      quantity: json['quantity'],
    );
  }
}

class Order {
  final int id;
  final double totalPrice;
  final String address;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.totalPrice,
    required this.address,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      totalPrice: double.parse(json['total_price'].toString()),
      address: json['address'],
      createdAt: DateTime.parse(json['created_at']),
      items: json['arrayOfObjects'] != null
          ? (json['arrayOfObjects'] as List)
              .map((i) => OrderItem.fromJson(i as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}
