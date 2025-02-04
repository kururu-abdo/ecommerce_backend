import 'package:ecommerce_app/database.dart';
import 'package:ecommerce_app/models/payment.dart';
import 'package:ecommerce_app/models/payment_gateway.dart';


class PaymentService {
  factory PaymentService() => _instance;
  PaymentService._internal();
  static final PaymentService _instance = PaymentService._internal();

  final List<Payment> _payments = [];

  List<PaymentGateway> _paymentGatways =[];
/*
  // Process payment (Mock)
  Payment processPayment(Payment payment) {
    final processedPayment = Payment(
      orderId: payment.orderId,
      amount: payment.amount,
      paymentMethod: payment.paymentMethod,
      status: 'successful', // Mock success status
    );
    _payments.add(processedPayment);
    return processedPayment;
  }

  // Retrieve payment details
  Payment? getPayment(String orderId) {
    return _payments.firstWhere((payment) => 
    payment.orderId == orderId, 
    
    // orElse: () => null
    
    );
  }
  */

  Future<List<PaymentGateway>> getPaymentGatways()async {
   try {
      final db = Database();
    final connection = await db.connection;
    final result = await connection.query('SELECT * from payment_methods');

    if (result.isEmpty) {
      _paymentGatways =[];
    }

   _paymentGatways = result.map((row){
return
PaymentGateway.fromJson(row.fields);
   }).toList();
   } catch (e) {
    print(e);
      _paymentGatways =[];
   }

   return  _paymentGatways;
  }

}
