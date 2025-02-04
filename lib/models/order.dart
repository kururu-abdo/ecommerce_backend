class Order {

  Order({
    required this.id,
    required this.customerId,
    // required this.products,
    required this.totalAmount,
    required this.tax,
    required this.discount,
    required this.grandTotal,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      // products: List<Map<String, dynamic>>.from(json['products']),
      totalAmount: json['totalAmount'] as double,
      tax: json['tax'] as double,
      discount: json['discount'] as double,
      grandTotal: json['grandTotal'] as double,
      paymentStatus: json['paymentStatus'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  final String id;
  final String customerId;
  // final List<Map<String, dynamic>> products;
  final double totalAmount; // Subtotal before taxes and discounts
  final double tax;         // Tax amount applied
  final double discount;    // Discount applied
  final double grandTotal;  // Final total after taxes and discounts
  final String paymentStatus;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      // 'products': products,
      'totalAmount': totalAmount,
      'tax': tax,
      'discount': discount,
      'grandTotal': grandTotal,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
