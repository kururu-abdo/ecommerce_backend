// routes/notifications/post.dart
import 'package:dart_frog/dart_frog.dart';
import 'package:ecommerce_app/models/notification.dart';

Future<Response> onRequest(RequestContext context) async {
  final requestData = await context.request.json();

  final  token = requestData['token']; // Device FCM token
  final  title = requestData['title'];
  final  body = requestData['body'];

  try {
    // FirebaseAdmin.instance
    // await FirebaseAdmin.instance .s(
    //   Message(
    //     token: token,
    //     notification: Notification(
    //       title: title,
    //       body: body,
    //     ),
    //   ),
    // );
 final newNotification = Notification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: body['userId'] as String,
        title: body['title'] as String,
        message: body['message'] as String,
        type: body['type'] as String,
        isRead: false,
        createdAt: DateTime.now(),
      );
    return Response.json(
      body: {'status': 'success', 'message': 'Notification sent successfully'},
    );
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'status': 'error', 'message': e.toString()},
    );
  }
}
