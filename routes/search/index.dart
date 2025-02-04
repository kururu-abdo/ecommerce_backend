import 'package:dart_frog/dart_frog.dart';

import '../../services/product_service.dart';
import '../../services/user_service.dart';

Future<Response> onRequest(RequestContext context) async {
  // Fetch banners that are currently valid
  final userService = context.read<UserService>();
  final productService=   context.read<ProductService>();
     final request = context.request;
     final params = request.uri.queryParameters;
    final str = params['str'];
   final products = await productService.searchProducts(str.toString());
      final    categories = await productService.searchCategories(str.toString());

  return Response.json(
    body: {
     'products': products.map((p)=> p.toJson()).toList(),
     'categories':categories.map((c)=> c).toList(),
    },
  );
}
