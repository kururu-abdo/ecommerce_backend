class Payment { // e.g., "successful", "failed"

  Payment({
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    this.status = "pending",
  });
  final String orderId;
  final double amount;
  final String paymentMethod; // e.g., "credit_card", "paypal"
  final String status;

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'status': status,
      };
}
