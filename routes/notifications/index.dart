import 'package:dart_frog/dart_frog.dart';

import '../../services/notification_service.dart';


Future<Response> onRequest(RequestContext context) async {
  // final userId = context.request.body()['userId'];
  final query = context.request.uri.queryParameters;
  final notificationService = context.read<NotificationService>();
  // Filter by user ID
  final userNotifications =await notificationService.getNotifications(1);
  

  // Filter by read status (if specified)
  if (query['isRead'] != null) {
    final isRead = query['isRead'] == 'true';
    return Response.json(
      body: userNotifications
          .where((n) => n.isRead == isRead)
          .map((n) => n.toJson())
          .toList(),
    );
  }

  return Response.json(
    body: userNotifications.map((n) => n.toJson()).toList(),
  );
}
