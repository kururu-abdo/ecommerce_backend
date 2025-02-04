import 'package:dart_frog/dart_frog.dart';

import '../../services/order_service.dart';


Future<Response> onRequest(RequestContext context) async {
    final orderService = context.read<OrderService>();

  final payload = await context.request.json() as Map<String, dynamic>;

  final orderId = payload['order_id'];
  final status = payload['status'];

  if (orderId == null || status == null) {
    return Response.json(statusCode: 400, body: {'error': 'Order ID and status are required'});
  }

 await orderService.changeOrderStatus(int.parse(orderId.toString()), int.parse(status.toString()));

  return Response.json(body: {'message': 'Order status updated', 'status':status});
}
