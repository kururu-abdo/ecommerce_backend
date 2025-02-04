import 'package:dart_frog/dart_frog.dart';
import '../../services/cart_service.dart';



Future<Response> onRequest(RequestContext context) async {
  final cartService = context.read<CartService>();
  if (context.request.method == HttpMethod.delete) {
    cartService.clearCart();
    return Response.json(body: {'message': 'Cart cleared'});
  } else {
    return Response(statusCode: 405);
  }
}
