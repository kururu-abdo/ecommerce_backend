import 'package:dart_frog/dart_frog.dart';

import '../../services/product_service.dart';
import '../../services/user_service.dart';



Future<Response> onRequest(RequestContext context) async {
final request = context.request;
   final headers = request.headers;
  final payload = await context.request.json() as Map<String, dynamic>;
  final productId = payload['product_id'];
  final authHeader = context.request.headers['Authorization'];
  final favoriteService = context.read<ProductService>();
final userService = context.read<UserService>();
if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(statusCode: 400, body: {'error': 'User ID and product ID are required'});

 }

 final token = authHeader!.substring(7); // Remove 'Bearer ' prefix
  // final userId = context.request.headers['userId'];
var user = await userService.verifyToken(token);
  if (user == null || productId == null) {
    return Response.json(statusCode: 400, body: {'error': 'User ID and product ID are required'});
  }
// final favoriteService = context.read<ProductService>();
  favoriteService.addFavorite(user.id.toString(), productId.toString());
  return Response.json(statusCode: 201, body: {'message': 'Product added to favorites'});
}
