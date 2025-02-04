import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final orderId = context.request.uri.queryParameters['orderId'];
  final body = await context.request.json();
  final status = body['status'];

  // TODO: Update the status of the order in the database

  return Response.json(
    body: {'message': 'Order status updated', 'orderId': orderId, 'status': status},
  );
}
