import 'package:dart_frog/dart_frog.dart';
import 'package:ecommerce_app/models/user.dart';

import '../../services/cart_service.dart';
import '../../services/user_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: Retrieve cart items for the current user
  final userService = context.read<UserService>();
    final cartService = context.read<CartService>();

  final cartItems = []; // List of CartItem objects
  final request = context.request;
  //  final headers = request.headers;
  //  // Extract the Authorization header
  // final authHeader = context.request.headers['Authorization'];

  // if (authHeader == null || !authHeader.startsWith('Bearer ')) {
  //   return Response.json(
  //     body: {'error': 'Missing or invalid Authorization header'},
  //     statusCode: 401,
  //   );
  // }

  // Extract the token from the header
  // final token = authHeader.substring(7); // Remove 'Bearer ' prefix
  final user =context.read<User?>();
  if (user==null) {
    return Response.json(
      body: {'error': 'UnAuthorized'},
      statusCode: 401,
    );
  }
final items = await cartService.getItems(user.id!);
  
  return Response.json(
    body: items.map((item) => item.toJson()).toList(),
  );
}
