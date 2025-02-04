import 'package:dart_frog/dart_frog.dart';

import '../../services/order_service.dart';
import '../../services/user_service.dart';

Future<Response> onRequest(RequestContext context) async {
final authHeader = context.request.headers['Authorization'];
  final userService = context.read<UserService>();
final params = context.request.uri.queryParameters;
late String status;

switch (int.parse(params['status'].toString())) {
  case 0:
    status = 'pending';

     case 1:
    status = 'confirmed';
case 2:
    status = 'shipped';
case 3:
    status = 'deliverd';
  default:
      status = 'pending';

}

  final orderService = context.read<OrderService>();
if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(statusCode: 401, body: {'error': 'UnAuthenticated'});

  }
  final token = authHeader.substring(7); // Remove 'Bearer ' prefix
  // TODO: Fetch product and check stock availability
  final user =await userService.verifyToken(token);
  if (user == null) {
    return Response.json(statusCode: 401, body: {'error': 'UnAuthenticated'});
  }
  // TODO: Retrieve orders for the specified user from the database
  
  final orders = await orderService.getOrders(int.parse(user.id!) , status);  // List of Order objects


  return Response.json(
    body: {'orders': orders.map((order) => order).toList()},
  );
}



/*


import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../../lib/services/cart_service.dart';
import '../../lib/services/order_service.dart';
import '../../lib/models/cart_item.dart';

final cartService = CartService();
final orderService = OrderService();

Future<Response> onRequest(RequestContext context) async {
  final userId = context.request.headers['userId'];
  final addressId = context.request.headers['addressId'];

  if (userId == null || addressId == null) {
    return Response.json(statusCode: 400, body: {'error': 'User ID and Address ID are required'});
  }

  if (context.request.method == HttpMethod.post) {
    final cartItems = cartService.getCartItems(userId);
    if (cartItems.isEmpty) {
      return Response.json(statusCode: 400, body: {'error': 'Cart is empty'});
    }

    final order = orderService.createOrder(userId, addressId, cartItems);
    cartService.clearCart(userId);

    return Response.json(statusCode: 201, body: order.toJson());
  }

  return Response(statusCode: 405);
}

*/
