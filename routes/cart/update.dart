import 'package:dart_frog/dart_frog.dart';

import '../../services/cart_service.dart';
import '../../services/user_service.dart';



Future<Response> onRequest(RequestContext context) async {
 final userService = context.read<UserService>();
    final cartService = context.read<CartService>();

  if (context.request.method == HttpMethod.patch) {
    final payload = await context.request.json() as Map<String, dynamic>;
    final itemId = payload['id'];
    final quantity = payload['quantity'];
 // Step 1: Extract the token from the Authorization header
  final authHeader = context.request.headers['Authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      body: {'error': 'Authorization token missing or invalid'},
      statusCode: 401,
    );
  }
    if (itemId == null || quantity == null) {
      return Response.json(
        statusCode: 400,
        body: {'error': 'Item ID and quantity are required'},
      );
    }
final token = authHeader.substring(7);
final user = await userService.verifyToken(token);
if (user==null) {
   return Response.json(
        statusCode: 401,
        body: {'error': 'UnAuthenticated'},
      );
}
   await cartService.updateItem(int.parse(user.id!),int.parse(itemId.toString()), int.parse(quantity.toString()));
    return Response.json(body: {'message': 'Cart item updated'}); 
     
  } else {
    return Response(statusCode: 405);
  }
}
