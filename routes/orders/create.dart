import 'package:dart_frog/dart_frog.dart';
import 'package:ecommerce_app/models/new_order.dart';

import '../../services/cart_service.dart';
import '../../services/order_service.dart';
import '../../services/user_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final orderService = context.read<OrderService>();
  final userService =  context.read<UserService>();
  final cartService =  context.read<CartService>();

final authHeader = context.request.headers['Authorization'];

  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      body: {'error': 'Missing or invalid Authorization header'},
      statusCode: 401,
    );
  }

  // Extract the token from the header
  final token = authHeader.substring(7); // Remove 'Bearer ' prefix
  // TODO: Fetch product and check stock availability
  final user =await userService.verifyToken(token);
  if (user==null) {
    return Response.json(
      body: {'error': 'UnAuthorized'},
      statusCode: 401,
    );
  }


  final body = await context.request.json();
 

   
     final items = 
    // body['items'].cast<List<Map<String,dynamic>>>()
    
    body['items'] ;
if (items is! List<dynamic>) {
      return Response.json(
       body:  {'error': '"items" must be a list of order items.'},
        statusCode: 400,
      );
    }
 final List<Map<String, dynamic>> orderItems = items
        .whereType<Map<String, dynamic>>()
        .toList();

  // Calculate total price
  

  // final order = Order(
  //   id: 'orderId',
  //   userId: userId,
  //   items: items,
  //   totalPrice: totalPrice,
  //   status: 'Pending',
  // );
// Parse request body
      // final products = List<Map<String, dynamic>>.from(body['products']);
      // final totalAmount = body['total_amount'] as double;
        var totalAmount = 0.0;
        for (final item in items) {
totalAmount+= (double.parse(item['price'].toString())  * double.parse(item['quantity'].toString()));
        }
      final addressId = int.parse(body['address_id'].toString());
      final note = body['note'].toString();

      // STEP 1: Calculate Tax
      const taxRate = 0.15; // 10% tax rate
      final tax = totalAmount * taxRate;

      // STEP 2: Apply Discount
      const discountRate = 0.0; // 5% discount rate
      final discount = totalAmount*discountRate ;
 final shipping = 5.0;
      // STEP 3: Compute Grand Total
      final grandTotal = totalAmount +shipping + tax - discount;

      // STEP 4: Save Order (Mock Database)
      final newOrder = NewOrder(
        
        id: '',
        delivery: 0, 

        products: orderItems,
        customerId: int.parse(user.id!),
        addressId: addressId,
        status: 'pending',
        // products: products,
        totalAmount: totalAmount,
        tax: tax,
        discount: discount,
        grandTotal: grandTotal,
        note: note, // Default payment status
        createdAt: DateTime.now(),
      );

      // mockOrdersDb.add(newOrder);
await orderService.createOrder(newOrder);
await cartService.clearMyCart( int.parse(user.id!),);
      return Response.json(
        body: {'message': 'order sent'},
      );


  
}
