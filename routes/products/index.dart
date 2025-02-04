import 'package:dart_frog/dart_frog.dart';
import 'package:ecommerce_app/models/product.dart';

import '../../services/product_service.dart';
import '../../services/user_service.dart';

List<Map<String, dynamic>> products = <Map<String, dynamic>>[];

Future<Response> onRequest(RequestContext context) async {
 final productService  = context.read<ProductService>();
 final userService  = context.read<UserService>();

 late Response response;
  if (context.request.method == HttpMethod.get) {
var userProducts=<Product>[];
      final products = await productService.getProducts();

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
    userProducts = products;
  }else{
 // Extract the token from the header
  final token = authHeader.substring(7); // Remove 'Bearer ' prefix
  // TODO: Fetch product and check stock availability
  final user =await userService.verifyToken(token);
  if (user==null) {
       userProducts = products;
  }else{

for (final p in products) {
  final isFavorite = await productService.isFavorite(user.id.toString(), p.id);
      p.isFavorite=isFavorite;
      userProducts.add(p);
}

    
  }

 
  }

 
    // Return list of products
    response= Response.json(
      body: {
        'products':userProducts.map((p)=>p.toJson()).toList(),
      },
    );
  } else if (context.request.method == HttpMethod.post) {
    // Create a new product
    final body = await context.request.json();
    final newProduct = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': body['name'],
      'price': body['price'],
      'description': body['description'],
    };
    products.add(newProduct);

    response= Response.json(
      statusCode: 201,
      body: newProduct,
    );
  }

  return response;
}
