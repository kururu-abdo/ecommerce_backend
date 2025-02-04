class NewOrder {

  NewOrder({
    required this.id,
    required this.customerId,
    required this.products,
    required this.totalAmount,
    required this.tax,
    required this.discount,
    required this.grandTotal,
    required this.note,
    required this.createdAt,
    required this.addressId,
    required this.status,
    required this.delivery
  });

  factory NewOrder.fromJson(Map<String, dynamic> json) {
    return NewOrder(
      id: json['id'] as String,
      customerId: json['customerId'] as int,
      products: List<Map<String, dynamic>>.from(json['items'] as List<Map<String,dynamic>>),
      totalAmount: json['totalAmount'] as double,
      tax: json['tax'] as double,
      discount: json['discount'] as double,
      grandTotal: json['grandTotal'] as double,
      note: json['note'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      addressId: json['address_id'] as int ,
      status: json['status'] as String,
      delivery: json['delivery'] as double

    );
  }
  final String id;
  final int customerId;
  final int addressId;
  final List<Map<String, dynamic>> products;
  final double totalAmount; // Subtotal before taxes and discounts
  final double tax;         // Tax amount applied
  final double discount;    // Discount applied
    final double delivery;    // Discount applied

  final double grandTotal;  // Final total after taxes and discounts
  final String note;
  final String? status;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'products': products,
      'totalAmount': totalAmount,
      'tax': tax,
      'discount': discount,
      'grandTotal': grandTotal,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
