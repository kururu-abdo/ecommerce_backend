
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../services/product_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final productService = context.read<ProductService>();
  final products = await productService.getCategoryProducts(id);
    // final cartRepository = context.read<CartRepository>();
    switch (context.request.method) {
      case HttpMethod.get:
        return Response.json(body: 
    {
      'products':products.map((item)=> item).toList(),
    },);
      default:
       return Response(statusCode: HttpStatus.methodNotAllowed);
    }
  
}