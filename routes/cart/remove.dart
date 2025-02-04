import 'package:dart_frog/dart_frog.dart';

import '../../services/cart_service.dart';
import '../../services/user_service.dart';


Future<Response> onRequest(RequestContext context) async {
 var userService = context.read<UserService>();
    var cartService = context.read<CartService>();

  if (context.request.method == HttpMethod.delete) {
    final payload = await context.request.json() as Map<String, dynamic>;
    final itemId = payload['id'];

    if (itemId == null) {
      return Response.json(
        statusCode: 400,
        body: {'error': 'Item ID is required'},
      );
    }

    cartService.removeItem(itemId.toString());
    return Response.json(body: {'message': 'Cart item removed'});
  } else {
    return Response(statusCode: 405);
  }
}
