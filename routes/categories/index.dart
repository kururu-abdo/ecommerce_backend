import 'package:dart_frog/dart_frog.dart';

import '../../services/product_service.dart';


Future<Response> onRequest(RequestContext context) async {
  final productService = context.read<ProductService>();
  final categories = await productService.getCategories();
    // final cartRepository = context.read<CartRepository>();
    
  return Response.json(
      body: categories,
    );
}