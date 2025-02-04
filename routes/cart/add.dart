import 'package:dart_frog/dart_frog.dart';
import 'package:ecommerce_app/models/cart_item.dart';

import '../../services/cart_service.dart';
import '../../services/user_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final body = await context.request.json();
  final userService = context.read<UserService>();
    final cartService = context.read<CartService>();
  final productId = body['product_id'];
    final produtName = body['name'];

  final quantity = body['quantity'];
 final request = context.request;
   final headers = request.headers;
   // Extract the Authorization header
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
  // Add item to user's cart in the database or session
  // For example:
  // final cartItem = CartItem(productId: productId, quantity: quantity);
  // Save cartItem to the user's cart
await  cartService.addItem(CartItem(
  arName: '',
  enName: '',
  urlImage: '',
  product_id: int.parse(productId.toString()),
  userId:user.id.toString() ,
  id:  productId.toString(), name: produtName.toString(), 
  price: 0,  quantity: int.parse(quantity.toString()),),);
  return Response.json(
    body: {'message': 'Item added to cart',
    //  'cartItem': cartItem.toJson()
    },
  );
}
