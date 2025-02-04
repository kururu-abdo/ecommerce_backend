import 'package:dart_frog/dart_frog.dart';

import '../../services/order_service.dart';


Future<Response> onRequest(RequestContext context) async {
    final orderService = context.read<OrderService>();

  final payload = await context.request.json() as Map<String, dynamic>;

  final orderId = payload['orderId'];
  final status = payload['status'];

  if (orderId == null || status == null) {
    return Response.json(statusCode: 400, body: {'error': 'Order ID and status are required'});
  }

  // orderService.updateOrderStatus(orderId, status);
  return Response.json(body: {'message': 'Order status updated'});
}
