import 'package:dart_frog/dart_frog.dart';
import 'package:ecommerce_app/models/product.dart';

import '../../services/product_service.dart';
import '../../services/user_service.dart';

final productService = ProductService();

Future<Response> onRequest(RequestContext context) async {
  final productService  = context.read<ProductService>();
 final userService  = context.read<UserService>();
var userProducts=<Product>[];
      // final products = await productService.getProducts();
        final topSales = await productService.getTopSales();
   //check if its favorite
   final request = context.request;
   final headers = request.headers;
   // Extract the Authorization header
  final authHeader = context.request.headers['Authorization'];

  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    // return Response.json(
    //   body: {'error': 'Missing or invalid Authorization header'},
    //   statusCode: 401,
    // );
    userProducts = topSales;
  }else{
 // Extract the token from the header
  final token = authHeader.substring(7); // Remove 'Bearer ' prefix
  // TODO: Fetch product and check stock availability
  final user =await userService.verifyToken(token);
  if (user==null) {
       userProducts = topSales;
  }else{

    for (final product in topSales) {
       final isFavorite = await productService.isFavorite(user.id.toString(), product.id);
     product.isFavorite=isFavorite;
      userProducts.add(product);
    }
    
    
  }

 
  }

  return Response.json(body:userProducts);
}
