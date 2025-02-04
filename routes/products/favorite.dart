import 'package:dart_frog/dart_frog.dart';

import '../../services/product_service.dart';





Future<Response> onRequest(RequestContext context) async {
  final productService  = context.read<ProductService>();
      final body = await context.request.json();
  final isFavourite= bool.parse( body['is_favourite'].toString());
  final userId = body['user_id'].toString();
  final productId = body['product_id'].toString();
  if (isFavourite) {
    await productService.removeFavorite(userId, productId);
    return Response.json(
    body: {
      'message': 'removed',
    },
  );
  }else{
        await productService.addFavorite(userId, productId);

return Response.json(
    body: {
      'message': 'Added to favorites',
    },
  );
  }
  
}
