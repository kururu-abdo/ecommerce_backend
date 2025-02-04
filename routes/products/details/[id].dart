import 'package:dart_frog/dart_frog.dart';

import '../../../services/product_service.dart';
import '../../../services/user_service.dart';


Future<Response> onRequest(RequestContext context, String id) async {
  final productService  = context.read<ProductService>();

  final request = context.request;
   final headers = request.headers;
   // Extract the Authorization header
  final authHeader = context.request.headers['Authorization'];
final favoriteService = context.read<ProductService>();
final userService = context.read<UserService>();
var token='';
 if (authHeader == null || !authHeader.startsWith('Bearer ')) {

 }

if (authHeader!=null) {
      token = authHeader.substring(7); // Remove 'Bearer ' prefix

}  // final userId = context.request.headers['userId'];
final user = await userService.verifyToken(token);

   final product = await productService.getProduct(
    user?.id
    ,
    id,);
  if (product==null) {
   return Response.json(
    statusCode: 404,
    body: 'no product',
  );
}

return Response.json(
    body: product.toJson(),
  );
}
