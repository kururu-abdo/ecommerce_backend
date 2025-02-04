// import 'dart:convert';
// import 'package:dart_frog/dart_frog.dart';

// import '../../lib/models/payment.dart';
// import '../../services/order_service.dart';
// import '../../services/payment_service.dart';

// final paymentService = PaymentService();
// // final orderService = OrderService();

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
//   final payload = await context.request.json() as Map<String, dynamic>;

//   final orderId = payload['orderId'];
//   final paymentMethod = payload['paymentMethod'];
//   final amount = payload['amount'];

//   if (orderId == null || paymentMethod == null || amount == null) {
//     return Response.json(statusCode: 400, body: {'error': 'Order ID, payment method, and amount are required'});
//   }

//   // Process payment (mock)
//   final payment = Payment(orderId: orderId, amount: amount, paymentMethod: paymentMethod);
//   final processedPayment = paymentService.processPayment(payment);

//   if (processedPayment.status == "successful") {
//     orderService.updateOrderStatus(orderId, "paid");
//     return Response.json(statusCode: 200, body: {'message': 'Payment successful', 'payment': processedPayment.toJson()});
//   }

  return Response.json(statusCode: 400, body: {'error': 'Payment failed'});
}
