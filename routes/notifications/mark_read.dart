import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.patch) {
    final id = context.request.body();

    // Find the notification
    final notification = [].firstWhere((n) => n.id == id, orElse: () => null);
    if (notification == null) {
      return Response.json(
        statusCode: 404,
        body: {'error': 'Notification not found'},
      );
    }

    // Mark as read
    notification.isRead = true;
    notification.readAt = DateTime.now();

    return Response.json(
      body: {'message': 'Notification marked as read', 'notification': notification.toJson()},
    );
  }

  return Response(statusCode: 405, body: 'Method not allowed');
}
