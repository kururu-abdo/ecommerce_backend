import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';

import '../../services/product_service.dart';
import '../../services/user_service.dart';


Future<Response> onRequest(RequestContext context) async {
 final request = context.request;
   final headers = request.headers;
   // Extract the Authorization header
  final authHeader = headers['Authorization'];
  log(authHeader.toString());
    var token = '';
final favoriteService = context.read<ProductService>();
final userService = context.read<UserService>();
 if (authHeader == null || !authHeader.startsWith('Bearer ')) {

 }
  // final userId = context.request.headers['userId'];
if (authHeader!=null) {
      token = authHeader.substring(7); // Remove 'Bearer ' prefix

}

final user = await userService.verifyToken(token);
  if (user == null) {
    return Response.json(statusCode: 400, body: {'error': 'User ID is required'});
  }

  final favorites =await favoriteService.getFavorites(user.id.toString());
  return Response.json(body: {'favorites': favorites});
}
